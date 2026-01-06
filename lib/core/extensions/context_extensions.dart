/// BuildContext extensions for easy access to theme, navigation, etc.
library;

import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import '../utils/platform_utils.dart';

/// Extensions on BuildContext for easy access to common properties
extension ContextExtensions on BuildContext {
  // Theme shortcuts
  ThemeData get theme => Theme.of(this);
  ColorScheme get colorScheme => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  AppThemeExtension get appTheme => theme.appExtension;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Media query shortcuts
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  EdgeInsets get padding => mediaQuery.padding;
  EdgeInsets get viewPadding => mediaQuery.viewPadding;
  EdgeInsets get viewInsets => mediaQuery.viewInsets;
  double get bottomPadding => padding.bottom;
  double get topPadding => padding.top;
  Orientation get orientation => mediaQuery.orientation;
  bool get isLandscape => orientation == Orientation.landscape;
  bool get isPortrait => orientation == Orientation.portrait;

  // Responsive breakpoints
  bool get isMobile => ScreenUtils.isMobileScreen(screenWidth);
  bool get isTablet => ScreenUtils.isTabletScreen(screenWidth);
  bool get isDesktop => ScreenUtils.isDesktopScreen(screenWidth);

  // Responsive value helper
  T responsive<T>({
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    return ScreenUtils.responsiveValue(
      screenWidth,
      mobile: mobile,
      tablet: tablet,
      desktop: desktop,
    );
  }

  // Navigation shortcuts
  NavigatorState get navigator => Navigator.of(this);
  void pop<T>([T? result]) => navigator.pop(result);
  Future<T?> push<T>(Route<T> route) => navigator.push(route);
  Future<T?> pushNamed<T>(String routeName, {Object? arguments}) =>
      navigator.pushNamed<T>(routeName, arguments: arguments);
  void popUntil(bool Function(Route<dynamic>) predicate) =>
      navigator.popUntil(predicate);
  bool canPop() => navigator.canPop();

  // Scaffold shortcuts
  ScaffoldState get scaffold => Scaffold.of(this);
  ScaffoldMessengerState get scaffoldMessenger => ScaffoldMessenger.of(this);

  // Show snackbar
  void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
    Color? backgroundColor,
  }) {
    scaffoldMessenger.hideCurrentSnackBar();
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
        action: action,
        backgroundColor: backgroundColor,
      ),
    );
  }

  // Show success snackbar
  void showSuccessSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.primaryContainer,
    );
  }

  // Show error snackbar
  void showErrorSnackBar(String message) {
    showSnackBar(
      message,
      backgroundColor: colorScheme.errorContainer,
    );
  }

  // Focus
  FocusNode? get focusNode => FocusScope.of(this).focusedChild;
  void unfocus() => FocusScope.of(this).unfocus();
  void requestFocus([FocusNode? node]) => FocusScope.of(this).requestFocus(node);

  // Keyboard visibility
  bool get isKeyboardVisible => mediaQuery.viewInsets.bottom > 0;
}

/// Extensions for responsive padding based on screen size
extension ResponsivePadding on BuildContext {
  /// Get horizontal padding based on screen size
  double get horizontalPadding {
    if (isDesktop) return 48.0;
    if (isTablet) return 32.0;
    return 16.0;
  }

  /// Get vertical padding based on screen size
  double get verticalPadding {
    if (isDesktop) return 32.0;
    if (isTablet) return 24.0;
    return 16.0;
  }

  /// Get symmetric padding based on screen size
  EdgeInsets get responsivePadding => EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      );

  /// Get horizontal only padding
  EdgeInsets get responsiveHorizontalPadding =>
      EdgeInsets.symmetric(horizontal: horizontalPadding);
}

/// Extensions for dialog helpers
extension DialogExtensions on BuildContext {
  /// Show a simple alert dialog
  Future<bool?> showAlertDialog({
    required String title,
    required String content,
    String confirmText = 'OK',
    String? cancelText,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          if (cancelText != null)
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(cancelText),
            ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show a confirmation dialog
  Future<bool?> showConfirmDialog({
    required String title,
    required String content,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    bool isDestructive = false,
  }) async {
    return showDialog<bool>(
      context: this,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: isDestructive
                ? FilledButton.styleFrom(
                    backgroundColor: colorScheme.error,
                    foregroundColor: colorScheme.onError,
                  )
                : null,
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }

  /// Show a bottom sheet
  Future<T?> showAppBottomSheet<T>({
    required Widget child,
    bool isScrollControlled = true,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: this,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      builder: (context) => child,
    );
  }
}
