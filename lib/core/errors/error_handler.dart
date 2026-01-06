/// Global error handling for Innerverse
library;

import 'dart:async';
import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app_exception.dart';

/// Global error handler singleton
class ErrorHandler {
  ErrorHandler._();

  static final ErrorHandler _instance = ErrorHandler._();
  static ErrorHandler get instance => _instance;

  final List<ErrorLog> _errorLogs = [];
  List<ErrorLog> get errorLogs => List.unmodifiable(_errorLogs);

  /// Maximum number of error logs to keep
  static const int maxErrorLogs = 100;

  /// Callback for showing error UI
  void Function(ErrorLog error)? onError;

  /// Initialize error handling
  void initialize() {
    // Handle Flutter framework errors
    FlutterError.onError = _handleFlutterError;

    // Handle async errors not caught by Flutter
    PlatformDispatcher.instance.onError = _handlePlatformError;
  }

  /// Setup zone error handling (call this in main)
  static Future<void> runGuarded(Future<void> Function() app) async {
    await runZonedGuarded(
      () async {
        WidgetsFlutterBinding.ensureInitialized();
        instance.initialize();
        await app();
      },
      instance._handleZoneError,
    );
  }

  void _handleFlutterError(FlutterErrorDetails details) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: details.exceptionAsString(),
      stackTrace: details.stack?.toString() ?? 'No stack trace available',
      type: ErrorType.flutter,
      context: details.context?.toStringDeep() ?? 'No context',
    );

    _addErrorLog(errorLog);

    if (kDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    }

    onError?.call(errorLog);
  }

  bool _handlePlatformError(Object error, StackTrace stack) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: error.toString(),
      stackTrace: stack.toString(),
      type: ErrorType.platform,
      context: 'Platform error',
    );

    _addErrorLog(errorLog);

    if (kDebugMode) {
      debugPrint('Platform error: $error');
      debugPrint('Stack trace: $stack');
    }

    onError?.call(errorLog);

    // Return true to indicate the error was handled
    return true;
  }

  void _handleZoneError(Object error, StackTrace stack) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: error.toString(),
      stackTrace: stack.toString(),
      type: ErrorType.zone,
      context: 'Uncaught async error',
    );

    _addErrorLog(errorLog);

    if (kDebugMode) {
      debugPrint('Zone error: $error');
      debugPrint('Stack trace: $stack');
    }

    onError?.call(errorLog);
  }

  /// Handle isolate errors
  void handleIsolateError(IsolateSpawnException error) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: error.message,
      stackTrace: 'Isolate spawn error',
      type: ErrorType.isolate,
      context: 'Isolate error',
    );

    _addErrorLog(errorLog);
    onError?.call(errorLog);
  }

  /// Log a custom error
  void logError({
    required String message,
    String? stackTrace,
    ErrorType type = ErrorType.custom,
    String? context,
  }) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: message,
      stackTrace: stackTrace ?? StackTrace.current.toString(),
      type: type,
      context: context,
    );

    _addErrorLog(errorLog);
  }

  /// Log an exception
  void logException(AppException exception) {
    final errorLog = ErrorLog(
      timestamp: DateTime.now(),
      message: exception.message,
      stackTrace: exception.stackTrace?.toString() ?? StackTrace.current.toString(),
      type: ErrorType.app,
      context: exception.code,
    );

    _addErrorLog(errorLog);
  }

  void _addErrorLog(ErrorLog log) {
    _errorLogs.insert(0, log);

    // Keep only the latest errors
    while (_errorLogs.length > maxErrorLogs) {
      _errorLogs.removeLast();
    }
  }

  /// Clear all error logs
  void clearLogs() {
    _errorLogs.clear();
  }

  /// Get the most recent error
  ErrorLog? get lastError => _errorLogs.isNotEmpty ? _errorLogs.first : null;

  /// Get error logs as a formatted string
  String getLogsAsString() {
    if (_errorLogs.isEmpty) return 'No error logs';

    final buffer = StringBuffer();
    buffer.writeln('=== Innerverse Error Logs ===');
    buffer.writeln('Generated: ${DateTime.now().toIso8601String()}');
    buffer.writeln('Total errors: ${_errorLogs.length}');
    buffer.writeln();

    for (var i = 0; i < _errorLogs.length; i++) {
      final log = _errorLogs[i];
      buffer.writeln('--- Error ${i + 1} ---');
      buffer.writeln(log.toFormattedString());
      buffer.writeln();
    }

    return buffer.toString();
  }
}

/// Error log entry
class ErrorLog {
  final DateTime timestamp;
  final String message;
  final String stackTrace;
  final ErrorType type;
  final String? context;

  const ErrorLog({
    required this.timestamp,
    required this.message,
    required this.stackTrace,
    required this.type,
    this.context,
  });

  String toFormattedString() {
    final buffer = StringBuffer();
    buffer.writeln('Timestamp: ${timestamp.toIso8601String()}');
    buffer.writeln('Type: ${type.name}');
    if (context != null) buffer.writeln('Context: $context');
    buffer.writeln('Message: $message');
    buffer.writeln('Stack Trace:');
    buffer.writeln(stackTrace);
    return buffer.toString();
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'message': message,
        'stackTrace': stackTrace,
        'type': type.name,
        'context': context,
      };

  factory ErrorLog.fromJson(Map<String, dynamic> json) => ErrorLog(
        timestamp: DateTime.parse(json['timestamp'] as String),
        message: json['message'] as String,
        stackTrace: json['stackTrace'] as String,
        type: ErrorType.values.firstWhere(
          (e) => e.name == json['type'],
          orElse: () => ErrorType.custom,
        ),
        context: json['context'] as String?,
      );
}

/// Error types for categorization
enum ErrorType {
  flutter,
  platform,
  zone,
  isolate,
  app,
  database,
  storage,
  security,
  audio,
  export,
  custom,
}
