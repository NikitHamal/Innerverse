/// Debug screen for error display in Innerverse
library;

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/errors/error_handler.dart';

/// Debug screen for displaying crash logs and errors
class DebugScreen extends StatelessWidget {
  final ErrorLog? errorLog;
  final VoidCallback? onDismiss;

  const DebugScreen({
    super.key,
    this.errorLog,
    this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: const Text('Debug Log'),
        backgroundColor: colorScheme.errorContainer,
        foregroundColor: colorScheme.onErrorContainer,
        leading: onDismiss != null
            ? IconButton(
                icon: const Icon(Icons.close),
                onPressed: onDismiss,
              )
            : null,
        actions: [
          IconButton(
            icon: const Icon(Icons.copy),
            tooltip: 'Copy Log',
            onPressed: () => _copyLog(context),
          ),
          if (!kIsWeb) ...[
            IconButton(
              icon: const Icon(Icons.refresh),
              tooltip: 'Restart App',
              onPressed: () => _restartApp(context),
            ),
          ],
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Error summary
            _buildErrorSummary(context),

            // Log content
            Expanded(
              child: _buildLogContent(context),
            ),

            // Action buttons
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorSummary(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final log = errorLog ?? ErrorHandler.instance.lastError;

    if (log == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      color: colorScheme.errorContainer.withOpacity(0.3),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.error_outline,
                color: colorScheme.error,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error Occurred',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildErrorTypeBadge(context, log.type),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            log.message,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 8),
          Text(
            'Timestamp: ${_formatTimestamp(log.timestamp)}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorTypeBadge(BuildContext context, ErrorType type) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: colorScheme.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: colorScheme.error.withOpacity(0.3)),
      ),
      child: Text(
        type.name.toUpperCase(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: colorScheme.error,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildLogContent(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final logText = _getFullLogText();

    return Container(
      margin: const EdgeInsets.all(AppSizes.paddingM),
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(AppSizes.radiusM),
        border: Border.all(color: colorScheme.outline.withOpacity(0.3)),
      ),
      child: SingleChildScrollView(
        child: SelectableText(
          logText,
          style: const TextStyle(
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.5,
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(AppSizes.paddingM),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _copyLog(context),
              icon: const Icon(Icons.copy),
              label: const Text('Copy Log'),
            ),
          ),
          const SizedBox(width: 12),
          if (!kIsWeb) ...[
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _restartApp(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Restart'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
              ),
            ),
          ] else ...[
            Expanded(
              child: FilledButton.icon(
                onPressed: () => _reloadWeb(context),
                icon: const Icon(Icons.refresh),
                label: const Text('Reload'),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.error,
                  foregroundColor: colorScheme.onError,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _getFullLogText() {
    final log = errorLog ?? ErrorHandler.instance.lastError;

    if (log != null) {
      return log.toFormattedString();
    }

    return ErrorHandler.instance.getLogsAsString();
  }

  String _formatTimestamp(DateTime timestamp) {
    return '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-'
        '${timestamp.day.toString().padLeft(2, '0')} '
        '${timestamp.hour.toString().padLeft(2, '0')}:'
        '${timestamp.minute.toString().padLeft(2, '0')}:'
        '${timestamp.second.toString().padLeft(2, '0')}';
  }

  Future<void> _copyLog(BuildContext context) async {
    final logText = _getFullLogText();
    await Clipboard.setData(ClipboardData(text: logText));

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Log copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _restartApp(BuildContext context) {
    if (!kIsWeb) {
      exit(0);
    }
  }

  void _reloadWeb(BuildContext context) {
    // On web, just dismiss and hope for the best
    onDismiss?.call();
  }
}

/// Standalone error display widget for showing in dialogs
class ErrorDisplayDialog extends StatelessWidget {
  final ErrorLog error;

  const ErrorDisplayDialog({
    super.key,
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(
            Icons.error_outline,
            color: colorScheme.error,
          ),
          const SizedBox(width: 12),
          const Text('Error'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              error.message,
              style: theme.textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(8),
              ),
              constraints: const BoxConstraints(maxHeight: 200),
              child: SingleChildScrollView(
                child: SelectableText(
                  error.stackTrace,
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton.icon(
          onPressed: () async {
            await Clipboard.setData(
              ClipboardData(text: error.toFormattedString()),
            );
            if (context.mounted) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Error log copied')),
              );
            }
          },
          icon: const Icon(Icons.copy, size: 18),
          label: const Text('Copy'),
        ),
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Dismiss'),
        ),
      ],
    );
  }
}
