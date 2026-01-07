/// Backup service for local backup and restore in Innerverse
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/error_handler.dart';
import '../data/database/app_database.dart';

/// Backup metadata
class BackupMetadata {
  final DateTime createdAt;
  final String appVersion;
  final int personaCount;
  final int conversationCount;
  final int messageCount;
  final int timeCapsuleCount;
  final bool isEncrypted;

  const BackupMetadata({
    required this.createdAt,
    required this.appVersion,
    required this.personaCount,
    required this.conversationCount,
    required this.messageCount,
    required this.timeCapsuleCount,
    required this.isEncrypted,
  });

  Map<String, dynamic> toJson() => {
        'createdAt': createdAt.toIso8601String(),
        'appVersion': appVersion,
        'personaCount': personaCount,
        'conversationCount': conversationCount,
        'messageCount': messageCount,
        'timeCapsuleCount': timeCapsuleCount,
        'isEncrypted': isEncrypted,
      };

  factory BackupMetadata.fromJson(Map<String, dynamic> json) {
    return BackupMetadata(
      createdAt: DateTime.parse(json['createdAt'] as String),
      appVersion: json['appVersion'] as String,
      personaCount: json['personaCount'] as int,
      conversationCount: json['conversationCount'] as int,
      messageCount: json['messageCount'] as int,
      timeCapsuleCount: json['timeCapsuleCount'] as int,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
    );
  }
}

/// Result of a backup operation
class BackupResult {
  final bool success;
  final String? filePath;
  final String? error;
  final BackupMetadata? metadata;

  const BackupResult({
    required this.success,
    this.filePath,
    this.error,
    this.metadata,
  });
}

/// Result of a restore operation
class RestoreResult {
  final bool success;
  final String? error;
  final BackupMetadata? metadata;

  const RestoreResult({
    required this.success,
    this.error,
    this.metadata,
  });
}

/// Backup service for creating and restoring backups
class BackupService {
  final AppDatabase _database;

  BackupService(this._database);

  /// Create a backup of all data
  Future<BackupResult> createBackup({
    String? password,
    bool compress = true,
  }) async {
    try {
      // Gather all data
      final data = await _gatherBackupData();

      // Create metadata
      final metadata = BackupMetadata(
        createdAt: DateTime.now(),
        appVersion: AppMetadata.version,
        personaCount: data['personas']?.length ?? 0,
        conversationCount: data['conversations']?.length ?? 0,
        messageCount: data['messages']?.length ?? 0,
        timeCapsuleCount: data['timeCapsules']?.length ?? 0,
        isEncrypted: password != null,
      );

      // Build backup content
      final backupContent = {
        'metadata': metadata.toJson(),
        'data': data,
      };

      // Convert to JSON
      String jsonContent = const JsonEncoder.withIndent('  ').convert(backupContent);

      // Encrypt if password provided
      if (password != null) {
        jsonContent = _encryptContent(jsonContent, password);
      }

      // Compress if requested
      final Uint8List finalContent;
      if (compress) {
        finalContent = Uint8List.fromList(gzip.encode(utf8.encode(jsonContent)));
      } else {
        finalContent = Uint8List.fromList(utf8.encode(jsonContent));
      }

      // Save to file
      final filePath = await _saveBackup(finalContent, compress);

      return BackupResult(
        success: true,
        filePath: filePath,
        metadata: metadata,
      );
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Backup creation failed: $e',
        stackTrace: stack.toString(),
        type: ErrorType.storage,
      );
      return BackupResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Restore from a backup file
  Future<RestoreResult> restoreBackup({
    required String filePath,
    String? password,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return const RestoreResult(
          success: false,
          error: 'Backup file not found',
        );
      }

      // Read file content
      final bytes = await file.readAsBytes();

      // Decompress if needed
      String jsonContent;
      try {
        jsonContent = utf8.decode(gzip.decode(bytes));
      } catch (_) {
        jsonContent = utf8.decode(bytes);
      }

      // Decrypt if password provided
      if (password != null) {
        final decrypted = _decryptContent(jsonContent, password);
        if (decrypted == null) {
          return const RestoreResult(
            success: false,
            error: 'Invalid password or corrupted backup',
          );
        }
        jsonContent = decrypted;
      }

      // Parse JSON
      final backupData = jsonDecode(jsonContent) as Map<String, dynamic>;
      final metadata = BackupMetadata.fromJson(
        backupData['metadata'] as Map<String, dynamic>,
      );
      final data = backupData['data'] as Map<String, dynamic>;

      // Check if backup is encrypted but no password provided
      if (metadata.isEncrypted && password == null) {
        return const RestoreResult(
          success: false,
          error: 'This backup is encrypted. Please provide the password.',
        );
      }

      // Restore data
      await _restoreData(data);

      return RestoreResult(
        success: true,
        metadata: metadata,
      );
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Backup restore failed: $e',
        stackTrace: stack.toString(),
        type: ErrorType.storage,
      );
      return RestoreResult(
        success: false,
        error: e.toString(),
      );
    }
  }

  /// Pick a backup file
  Future<String?> pickBackupFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['innerverse', 'json', 'gz'],
        allowMultiple: false,
      );

      return result?.files.single.path;
    } catch (e) {
      debugPrint('Error picking backup file: $e');
      return null;
    }
  }

  /// Get backup directory path
  Future<String> getBackupDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backups');
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir.path;
  }

  /// List existing backups
  Future<List<BackupFileInfo>> listBackups() async {
    try {
      final backupDir = await getBackupDirectory();
      final dir = Directory(backupDir);

      if (!await dir.exists()) {
        return [];
      }

      final files = await dir
          .list()
          .where((entity) =>
              entity is File &&
              (entity.path.endsWith('.innerverse') ||
                  entity.path.endsWith('.gz')))
          .toList();

      final backups = <BackupFileInfo>[];
      for (final entity in files) {
        final file = entity as File;
        final stat = await file.stat();
        backups.add(BackupFileInfo(
          path: file.path,
          name: file.uri.pathSegments.last,
          size: stat.size,
          createdAt: stat.changed,
        ));
      }

      backups.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return backups;
    } catch (e) {
      debugPrint('Error listing backups: $e');
      return [];
    }
  }

  /// Delete a backup file
  Future<bool> deleteBackup(String filePath) async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error deleting backup: $e');
      return false;
    }
  }

  // ============================================================================
  // Private Methods
  // ============================================================================

  /// Gather all data for backup
  Future<Map<String, dynamic>> _gatherBackupData() async {
    // This is a placeholder - in a real implementation,
    // you would query the database for all data
    return {
      'personas': [],
      'conversations': [],
      'messages': [],
      'timeCapsules': [],
      'rituals': [],
      'userProfile': {},
      'spaceStatistics': [],
      'echoes': [],
    };
  }

  /// Restore data from backup
  Future<void> _restoreData(Map<String, dynamic> data) async {
    // This is a placeholder - in a real implementation,
    // you would clear existing data and insert the backup data
    debugPrint('Restoring ${data.length} data categories');
  }

  /// Save backup to file
  Future<String> _saveBackup(Uint8List content, bool isCompressed) async {
    final backupDir = await getBackupDirectory();
    final timestamp = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    final extension = isCompressed ? '.innerverse' : '.json';
    final fileName = 'innerverse_backup_$timestamp$extension';
    final filePath = '$backupDir/$fileName';

    final file = File(filePath);
    await file.writeAsBytes(content);

    return filePath;
  }

  /// Encrypt content with password
  String _encryptContent(String content, String password) {
    final key = sha256.convert(utf8.encode(password)).bytes;
    final contentBytes = utf8.encode(content);
    final encryptedBytes = <int>[];

    for (var i = 0; i < contentBytes.length; i++) {
      encryptedBytes.add(contentBytes[i] ^ key[i % key.length]);
    }

    return base64.encode(encryptedBytes);
  }

  /// Decrypt content with password
  String? _decryptContent(String encryptedContent, String password) {
    try {
      final key = sha256.convert(utf8.encode(password)).bytes;
      final encryptedBytes = base64.decode(encryptedContent);
      final decryptedBytes = <int>[];

      for (var i = 0; i < encryptedBytes.length; i++) {
        decryptedBytes.add(encryptedBytes[i] ^ key[i % key.length]);
      }

      return utf8.decode(decryptedBytes);
    } catch (e) {
      return null;
    }
  }
}

/// Information about a backup file
class BackupFileInfo {
  final String path;
  final String name;
  final int size;
  final DateTime createdAt;

  const BackupFileInfo({
    required this.path,
    required this.name,
    required this.size,
    required this.createdAt,
  });

  String get formattedSize {
    if (size < 1024) return '$size B';
    if (size < 1024 * 1024) return '${(size / 1024).toStringAsFixed(1)} KB';
    return '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
