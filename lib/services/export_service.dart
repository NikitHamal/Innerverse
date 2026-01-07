/// Export service for PDF, Markdown, and JSON exports in Innerverse
library;

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../core/constants/app_constants.dart';
import '../core/errors/error_handler.dart';
import '../domain/entities/conversation.dart';
import '../domain/entities/message.dart';
import '../domain/entities/persona.dart';

/// Export formats supported
enum ExportFormat {
  pdf,
  markdown,
  plainText,
  json,
  encryptedJson,
}

/// Export service for conversations and data
class ExportService {
  /// Export a conversation to the specified format
  Future<String?> exportConversation({
    required Conversation conversation,
    required List<Message> messages,
    required Map<int, Persona> personas,
    required ExportFormat format,
    String? encryptionPassword,
  }) async {
    try {
      final content = switch (format) {
        ExportFormat.pdf => await _generatePdf(
            conversation,
            messages,
            personas,
          ),
        ExportFormat.markdown => _generateMarkdown(
            conversation,
            messages,
            personas,
          ),
        ExportFormat.plainText => _generatePlainText(
            conversation,
            messages,
            personas,
          ),
        ExportFormat.json => _generateJson(
            conversation,
            messages,
            personas,
            encrypted: false,
          ),
        ExportFormat.encryptedJson => _generateJson(
            conversation,
            messages,
            personas,
            encrypted: true,
            password: encryptionPassword,
          ),
      };

      if (content == null) return null;

      // Save to file
      final fileName = _generateFileName(conversation, format);
      final filePath = await _saveFile(fileName, content, format);

      return filePath;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Export failed: $e',
        stackTrace: stack.toString(),
        type: ErrorType.export,
      );
      return null;
    }
  }

  /// Export multiple conversations
  Future<String?> exportMultipleConversations({
    required List<ConversationExportData> conversations,
    required ExportFormat format,
    String? encryptionPassword,
  }) async {
    try {
      final buffer = StringBuffer();

      for (final data in conversations) {
        final content = switch (format) {
          ExportFormat.markdown => _generateMarkdown(
              data.conversation,
              data.messages,
              data.personas,
            ),
          ExportFormat.plainText => _generatePlainText(
              data.conversation,
              data.messages,
              data.personas,
            ),
          _ => null,
        };

        if (content != null) {
          buffer.writeln(content);
          buffer.writeln('\n---\n');
        }
      }

      if (buffer.isEmpty) return null;

      final fileName =
          'innerverse_export_${DateFormat('yyyy-MM-dd').format(DateTime.now())}';
      final extension = _getExtension(format);
      final filePath = await _saveFile(
        '$fileName$extension',
        buffer.toString(),
        format,
      );

      return filePath;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Bulk export failed: $e',
        stackTrace: stack.toString(),
        type: ErrorType.export,
      );
      return null;
    }
  }

  /// Generate PDF content
  Future<Uint8List?> _generatePdf(
    Conversation conversation,
    List<Message> messages,
    Map<int, Persona> personas,
  ) async {
    try {
      final pdf = pw.Document(
        title: conversation.title ?? 'Innerverse Conversation',
        author: AppMetadata.appName,
        creator: AppMetadata.appName,
      );

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          header: (context) => _buildPdfHeader(context, conversation),
          footer: (context) => _buildPdfFooter(context),
          build: (context) => _buildPdfContent(messages, personas),
        ),
      );

      return pdf.save();
    } catch (e) {
      debugPrint('PDF generation error: $e');
      return null;
    }
  }

  pw.Widget _buildPdfHeader(
    pw.Context context,
    Conversation conversation,
  ) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            conversation.title ?? 'Innerverse Conversation',
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Space: ${conversation.spaceType.displayName}',
                style: const pw.TextStyle(fontSize: 12),
              ),
              pw.Text(
                'Mode: ${conversation.mode.displayName}',
                style: const pw.TextStyle(fontSize: 12),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'Date: ${DateFormat('MMMM d, yyyy').format(conversation.createdAt)}',
            style: const pw.TextStyle(
              fontSize: 10,
              color: PdfColors.grey700,
            ),
          ),
          pw.Divider(),
        ],
      ),
    );
  }

  pw.Widget _buildPdfFooter(pw.Context context) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            'Exported from ${AppMetadata.appName}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            'Page ${context.pageNumber} of ${context.pagesCount}',
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
        ],
      ),
    );
  }

  List<pw.Widget> _buildPdfContent(
    List<Message> messages,
    Map<int, Persona> personas,
  ) {
    return messages.map((message) {
      final persona = personas[message.personaId];
      final personaName = persona?.name ?? 'Unknown';
      final timestamp = DateFormat('MMM d, h:mm a').format(message.createdAt);

      return pw.Container(
        margin: const pw.EdgeInsets.only(bottom: 16),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.indigo100,
                    borderRadius: pw.BorderRadius.circular(4),
                  ),
                  child: pw.Text(
                    personaName,
                    style: pw.TextStyle(
                      fontSize: 10,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.indigo900,
                    ),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Text(
                  timestamp,
                  style: const pw.TextStyle(
                    fontSize: 9,
                    color: PdfColors.grey600,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 8),
            pw.Text(
              message.content,
              style: const pw.TextStyle(fontSize: 12),
            ),
          ],
        ),
      );
    }).toList();
  }

  /// Generate Markdown content
  String _generateMarkdown(
    Conversation conversation,
    List<Message> messages,
    Map<int, Persona> personas,
  ) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('# ${conversation.title ?? "Innerverse Conversation"}');
    buffer.writeln();
    buffer.writeln('**Space:** ${conversation.spaceType.displayName}');
    buffer.writeln('**Mode:** ${conversation.mode.displayName}');
    buffer.writeln(
      '**Date:** ${DateFormat('MMMM d, yyyy').format(conversation.createdAt)}',
    );
    buffer.writeln();
    buffer.writeln('---');
    buffer.writeln();

    // Messages
    for (final message in messages) {
      final persona = personas[message.personaId];
      final personaName = persona?.name ?? 'Unknown';
      final timestamp = DateFormat('MMM d, h:mm a').format(message.createdAt);

      buffer.writeln('### $personaName');
      buffer.writeln('*$timestamp*');
      buffer.writeln();
      buffer.writeln(message.content);
      buffer.writeln();
    }

    // Footer
    buffer.writeln('---');
    buffer.writeln('*Exported from ${AppMetadata.appName}*');

    return buffer.toString();
  }

  /// Generate plain text content
  String _generatePlainText(
    Conversation conversation,
    List<Message> messages,
    Map<int, Persona> personas,
  ) {
    final buffer = StringBuffer();

    // Header
    buffer.writeln('═' * 50);
    buffer.writeln(conversation.title ?? 'Innerverse Conversation');
    buffer.writeln('═' * 50);
    buffer.writeln();
    buffer.writeln('Space: ${conversation.spaceType.displayName}');
    buffer.writeln('Mode: ${conversation.mode.displayName}');
    buffer.writeln(
      'Date: ${DateFormat('MMMM d, yyyy').format(conversation.createdAt)}',
    );
    buffer.writeln();
    buffer.writeln('─' * 50);
    buffer.writeln();

    // Messages
    for (final message in messages) {
      final persona = personas[message.personaId];
      final personaName = persona?.name ?? 'Unknown';
      final timestamp = DateFormat('MMM d, h:mm a').format(message.createdAt);

      buffer.writeln('[$personaName] - $timestamp');
      buffer.writeln(message.content);
      buffer.writeln();
    }

    // Footer
    buffer.writeln('─' * 50);
    buffer.writeln('Exported from ${AppMetadata.appName}');

    return buffer.toString();
  }

  /// Generate JSON content
  String _generateJson(
    Conversation conversation,
    List<Message> messages,
    Map<int, Persona> personas, {
    required bool encrypted,
    String? password,
  }) {
    final data = {
      'exportedAt': DateTime.now().toIso8601String(),
      'app': AppMetadata.appName,
      'version': AppMetadata.version,
      'conversation': {
        'uuid': conversation.uuid,
        'title': conversation.title,
        'spaceType': conversation.spaceType.id,
        'mode': conversation.mode.id,
        'createdAt': conversation.createdAt.toIso8601String(),
        'updatedAt': conversation.updatedAt.toIso8601String(),
      },
      'personas': personas.values
          .map((p) => {
                'uuid': p.uuid,
                'name': p.name,
                'type': p.type.id,
              })
          .toList(),
      'messages': messages
          .map((m) => {
                'uuid': m.uuid,
                'personaId': m.personaId,
                'content': m.content,
                'createdAt': m.createdAt.toIso8601String(),
              })
          .toList(),
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(data);

    if (encrypted && password != null) {
      return _encryptContent(jsonString, password);
    }

    return jsonString;
  }

  /// Encrypt content with password
  String _encryptContent(String content, String password) {
    // Simple XOR encryption for demo purposes
    // In production, use proper AES encryption
    final key = sha256.convert(utf8.encode(password)).bytes;
    final contentBytes = utf8.encode(content);
    final encryptedBytes = <int>[];

    for (var i = 0; i < contentBytes.length; i++) {
      encryptedBytes.add(contentBytes[i] ^ key[i % key.length]);
    }

    return base64.encode(encryptedBytes);
  }

  /// Decrypt content with password
  String? decryptContent(String encryptedContent, String password) {
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

  /// Generate file name
  String _generateFileName(Conversation conversation, ExportFormat format) {
    final dateStr = DateFormat('yyyy-MM-dd_HHmmss').format(DateTime.now());
    final title = conversation.title?.replaceAll(RegExp(r'[^\w\s-]'), '') ??
        'conversation';
    final safeTitle = title.replaceAll(' ', '_').toLowerCase();
    final extension = _getExtension(format);

    return 'innerverse_${safeTitle}_$dateStr$extension';
  }

  /// Get file extension for format
  String _getExtension(ExportFormat format) {
    return switch (format) {
      ExportFormat.pdf => '.pdf',
      ExportFormat.markdown => '.md',
      ExportFormat.plainText => '.txt',
      ExportFormat.json => '.json',
      ExportFormat.encryptedJson => '.innerverse',
    };
  }

  /// Save content to file
  Future<String> _saveFile(
    String fileName,
    dynamic content,
    ExportFormat format,
  ) async {
    final directory = await getApplicationDocumentsDirectory();
    final exportDir = Directory('${directory.path}/exports');

    if (!await exportDir.exists()) {
      await exportDir.create(recursive: true);
    }

    final file = File('${exportDir.path}/$fileName');

    if (content is Uint8List) {
      await file.writeAsBytes(content);
    } else {
      await file.writeAsString(content as String);
    }

    return file.path;
  }

  /// Get export directory path
  Future<String> getExportDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    return '${directory.path}/exports';
  }

  /// Copy text to clipboard (returns the text for clipboard operation)
  String getClipboardText(
    Conversation conversation,
    List<Message> messages,
    Map<int, Persona> personas,
  ) {
    return _generatePlainText(conversation, messages, personas);
  }
}

/// Data class for bulk export
class ConversationExportData {
  final Conversation conversation;
  final List<Message> messages;
  final Map<int, Persona> personas;

  const ConversationExportData({
    required this.conversation,
    required this.messages,
    required this.personas,
  });
}
