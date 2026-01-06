/// Custom exception classes for Innerverse
library;

/// Base exception class for all app exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;

  const AppException({
    required this.message,
    this.code,
    this.originalError,
    this.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer('AppException: $message');
    if (code != null) buffer.write(' (code: $code)');
    if (originalError != null) buffer.write('\nOriginal error: $originalError');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    return buffer.toString();
  }
}

/// Exception for database operations
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for storage operations
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for security/authentication operations
class SecurityException extends AppException {
  const SecurityException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for export operations
class ExportException extends AppException {
  const ExportException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for audio operations
class AudioException extends AppException {
  const AudioException({
    required super.message,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Exception for validation errors
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException({
    required super.message,
    this.fieldErrors,
    super.code,
    super.originalError,
    super.stackTrace,
  });

  @override
  String toString() {
    final buffer = StringBuffer(super.toString());
    if (fieldErrors != null && fieldErrors!.isNotEmpty) {
      buffer.write('\nField errors:');
      fieldErrors!.forEach((field, error) {
        buffer.write('\n  $field: $error');
      });
    }
    return buffer.toString();
  }
}

/// Exception for feature not available on platform
class PlatformNotSupportedException extends AppException {
  final String feature;
  final String platform;

  const PlatformNotSupportedException({
    required this.feature,
    required this.platform,
    super.code,
  }) : super(message: '$feature is not supported on $platform');
}

/// Exception for operation cancelled by user
class OperationCancelledException extends AppException {
  const OperationCancelledException({
    super.message = 'Operation cancelled by user',
    super.code,
  });
}

/// Exception for timeout
class TimeoutException extends AppException {
  final Duration duration;

  const TimeoutException({
    required super.message,
    required this.duration,
    super.code,
    super.originalError,
    super.stackTrace,
  });
}

/// Result type for operations that can fail
sealed class Result<T> {
  const Result();

  /// Create a success result
  factory Result.success(T data) = Success<T>;

  /// Create a failure result
  factory Result.failure(AppException exception) = Failure<T>;

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is failure
  bool get isFailure => this is Failure<T>;

  /// Get data if success, null otherwise
  T? get dataOrNull => switch (this) {
        Success(data: final data) => data,
        Failure() => null,
      };

  /// Get exception if failure, null otherwise
  AppException? get exceptionOrNull => switch (this) {
        Success() => null,
        Failure(exception: final e) => e,
      };

  /// Map success value
  Result<R> map<R>(R Function(T data) mapper) => switch (this) {
        Success(data: final data) => Result.success(mapper(data)),
        Failure(exception: final e) => Result.failure(e),
      };

  /// Handle both cases
  R when<R>({
    required R Function(T data) success,
    required R Function(AppException exception) failure,
  }) =>
      switch (this) {
        Success(data: final data) => success(data),
        Failure(exception: final e) => failure(e),
      };

  /// Get data or throw exception
  T getOrThrow() => switch (this) {
        Success(data: final data) => data,
        Failure(exception: final e) => throw e,
      };

  /// Get data or default value
  T getOrDefault(T defaultValue) => switch (this) {
        Success(data: final data) => data,
        Failure() => defaultValue,
      };
}

/// Success result
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> && runtimeType == other.runtimeType && data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Failure result
final class Failure<T> extends Result<T> {
  final AppException exception;

  const Failure(this.exception);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure<T> &&
          runtimeType == other.runtimeType &&
          exception == other.exception;

  @override
  int get hashCode => exception.hashCode;
}
