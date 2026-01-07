/// Main Application Widget for Innerverse
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'core/constants/app_constants.dart';
import 'core/errors/error_handler.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'presentation/providers/app_providers.dart';
import 'presentation/screens/debug/debug_screen.dart';

/// Main application widget
class InnerverseApp extends ConsumerStatefulWidget {
  const InnerverseApp({super.key});

  @override
  ConsumerState<InnerverseApp> createState() => _InnerverseAppState();
}

class _InnerverseAppState extends ConsumerState<InnerverseApp>
    with WidgetsBindingObserver {
  late final GoRouter _router;
  ErrorLog? _currentError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _setupErrorHandler();
    _initializeRouter();
  }

  void _setupErrorHandler() {
    ErrorHandler.instance.onError = (error) {
      if (mounted) {
        setState(() {
          _currentError = error;
        });
      }
    };
  }

  void _initializeRouter() {
    final hasCompletedOnboarding = ref.read(hasCompletedOnboardingProvider);
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    _router = AppRouter.createRouter(
      hasCompletedOnboarding: hasCompletedOnboarding,
      isAuthenticated: isAuthenticated,
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        _onAppResumed();
        break;
      case AppLifecycleState.paused:
        _onAppPaused();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  void _onAppResumed() {
    // Re-authenticate if needed
    ref.read(securityServiceProvider).checkAuthenticationStatus();

    // Resume ambient audio if it was playing
    ref.read(audioServiceProvider).resumeIfWasPlaying();

    // Update last opened timestamp for dead man's switch
    ref.read(securityServiceProvider).updateLastOpened();
  }

  void _onAppPaused() {
    // Pause ambient audio
    ref.read(audioServiceProvider).pauseForBackground();

    // Lock app if configured
    if (ref.read(settingsProvider).lockOnBackground) {
      ref.read(isAuthenticatedProvider.notifier).state = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(themeModeProvider);

    // Show error screen if there's a critical error
    if (_currentError != null && !kIsWeb) {
      return _buildErrorApp();
    }

    return MaterialApp.router(
      title: AppMetadata.appName,
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      highContrastTheme: AppTheme.lightTheme,
      highContrastDarkTheme: AppTheme.darkTheme,
      routerConfig: _router,
      builder: (context, child) {
        // Apply global error boundary
        return _GlobalErrorBoundary(
          onError: (error) {
            ErrorHandler.instance.logError(
              message: error.toString(),
              type: ErrorType.flutter,
            );
          },
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }

  Widget _buildErrorApp() {
    return MaterialApp(
      title: AppMetadata.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: DebugScreen(
        errorLog: _currentError,
        onDismiss: () {
          setState(() {
            _currentError = null;
          });
        },
      ),
    );
  }
}

/// Global error boundary widget
class _GlobalErrorBoundary extends StatefulWidget {
  final Widget child;
  final void Function(Object error)? onError;

  const _GlobalErrorBoundary({
    required this.child,
    this.onError,
  });

  @override
  State<_GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<_GlobalErrorBoundary> {
  bool _hasError = false;
  Object? _error;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reset error state when dependencies change
    _hasError = false;
    _error = null;
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return _buildErrorWidget();
    }

    return widget.child;
  }

  Widget _buildErrorWidget() {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(height: 24),
              Text(
                'Something went wrong',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Text(
                'An unexpected error occurred. Please restart the app.',
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () {
                  setState(() {
                    _hasError = false;
                    _error = null;
                  });
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
