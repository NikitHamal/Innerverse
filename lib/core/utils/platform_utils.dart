/// Platform detection and utilities for cross-platform support
library;

import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// Platform detection utility
class PlatformUtils {
  PlatformUtils._();

  /// Check if running on web
  static bool get isWeb => kIsWeb;

  /// Check if running on mobile (Android or iOS)
  static bool get isMobile => !kIsWeb && (Platform.isAndroid || Platform.isIOS);

  /// Check if running on Android
  static bool get isAndroid => !kIsWeb && Platform.isAndroid;

  /// Check if running on iOS
  static bool get isIOS => !kIsWeb && Platform.isIOS;

  /// Check if running on desktop
  static bool get isDesktop =>
      !kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux);

  /// Check if running on macOS
  static bool get isMacOS => !kIsWeb && Platform.isMacOS;

  /// Check if running on Windows
  static bool get isWindows => !kIsWeb && Platform.isWindows;

  /// Check if running on Linux
  static bool get isLinux => !kIsWeb && Platform.isLinux;

  /// Check if biometric authentication is supported
  static bool get supportsBiometrics => isMobile;

  /// Check if screenshot blocking is supported
  static bool get supportsScreenshotBlocking => isAndroid;

  /// Check if haptic feedback is supported
  static bool get supportsHaptics => isMobile;

  /// Check if local notifications are supported
  static bool get supportsNotifications => isMobile;

  /// Check if panic button feature is supported
  static bool get supportsPanicButton => isMobile;

  /// Check if decoy PIN feature is supported
  static bool get supportsDecoyPin => isMobile;

  /// Check if voice-to-text is supported
  static bool get supportsVoiceToText => isMobile;

  /// Get the current platform name
  static String get platformName {
    if (isWeb) return 'Web';
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isMacOS) return 'macOS';
    if (isWindows) return 'Windows';
    if (isLinux) return 'Linux';
    return 'Unknown';
  }

  /// Get the appropriate storage path prefix
  static String get storagePath {
    if (isWeb) return '';
    if (isAndroid) return '/data/data/com.inner.verse/';
    if (isIOS) return '';
    return '';
  }
}

/// Screen size utilities
class ScreenUtils {
  ScreenUtils._();

  /// Mobile breakpoint
  static const double mobileBreakpoint = 600;

  /// Tablet breakpoint
  static const double tabletBreakpoint = 1024;

  /// Desktop breakpoint
  static const double desktopBreakpoint = 1440;

  /// Check if current screen width is mobile
  static bool isMobileScreen(double width) => width < mobileBreakpoint;

  /// Check if current screen width is tablet
  static bool isTabletScreen(double width) =>
      width >= mobileBreakpoint && width < tabletBreakpoint;

  /// Check if current screen width is desktop
  static bool isDesktopScreen(double width) => width >= tabletBreakpoint;

  /// Get responsive value based on screen width
  static T responsiveValue<T>(
    double width, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktopScreen(width) && desktop != null) return desktop;
    if (isTabletScreen(width) && tablet != null) return tablet;
    return mobile;
  }

  /// Get number of columns for grid based on screen width
  static int getGridColumns(double width) {
    if (isDesktopScreen(width)) return 4;
    if (isTabletScreen(width)) return 3;
    return 2;
  }

  /// Get appropriate padding based on screen width
  static double getHorizontalPadding(double width) {
    if (isDesktopScreen(width)) return 48;
    if (isTabletScreen(width)) return 32;
    return 16;
  }
}

/// Device capability flags
class DeviceCapabilities {
  final bool supportsBiometrics;
  final bool supportsScreenshotBlocking;
  final bool supportsHaptics;
  final bool supportsNotifications;
  final bool supportsPanicButton;
  final bool supportsDecoyPin;
  final bool supportsVoiceToText;

  const DeviceCapabilities({
    required this.supportsBiometrics,
    required this.supportsScreenshotBlocking,
    required this.supportsHaptics,
    required this.supportsNotifications,
    required this.supportsPanicButton,
    required this.supportsDecoyPin,
    required this.supportsVoiceToText,
  });

  factory DeviceCapabilities.current() {
    return DeviceCapabilities(
      supportsBiometrics: PlatformUtils.supportsBiometrics,
      supportsScreenshotBlocking: PlatformUtils.supportsScreenshotBlocking,
      supportsHaptics: PlatformUtils.supportsHaptics,
      supportsNotifications: PlatformUtils.supportsNotifications,
      supportsPanicButton: PlatformUtils.supportsPanicButton,
      supportsDecoyPin: PlatformUtils.supportsDecoyPin,
      supportsVoiceToText: PlatformUtils.supportsVoiceToText,
    );
  }
}
