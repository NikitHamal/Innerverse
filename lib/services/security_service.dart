/// Security service for PIN, biometrics, and privacy features in Innerverse
library;

import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/constants/app_constants.dart';
import '../core/errors/error_handler.dart';
import '../core/utils/platform_utils.dart';

/// Security service for authentication and privacy features
class SecurityService {
  final SharedPreferences _prefs;
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _isAuthenticated = false;
  bool _isDecoyMode = false;

  /// Whether the user is currently authenticated
  bool get isAuthenticated => _isAuthenticated;

  /// Whether we're in decoy mode (showing fake empty app)
  bool get isDecoyMode => _isDecoyMode;

  SecurityService(this._prefs);

  // ============================================================================
  // PIN Management
  // ============================================================================

  /// Check if a PIN has been set up
  bool get hasPinSetup => _prefs.getString(StorageKeys.pinHash) != null;

  /// Check if a decoy PIN has been set up
  bool get hasDecoyPinSetup => _prefs.getString(StorageKeys.decoyPinHash) != null;

  /// Set up a new PIN
  Future<bool> setupPin(String pin) async {
    if (pin.length < 4 || pin.length > 8) {
      return false;
    }

    try {
      final hash = _hashPin(pin);
      await _prefs.setString(StorageKeys.pinHash, hash);
      return true;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Failed to setup PIN: $e',
        stackTrace: stack.toString(),
        type: ErrorType.security,
      );
      return false;
    }
  }

  /// Set up a decoy PIN (shows fake empty app)
  Future<bool> setupDecoyPin(String pin) async {
    if (!PlatformUtils.isMobile) return false;
    if (pin.length < 4 || pin.length > 8) return false;

    // Decoy PIN must be different from real PIN
    if (_verifyPinHash(pin, _prefs.getString(StorageKeys.pinHash))) {
      return false;
    }

    try {
      final hash = _hashPin(pin);
      await _prefs.setString(StorageKeys.decoyPinHash, hash);
      return true;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Failed to setup decoy PIN: $e',
        stackTrace: stack.toString(),
        type: ErrorType.security,
      );
      return false;
    }
  }

  /// Change the current PIN
  Future<bool> changePin(String currentPin, String newPin) async {
    if (!verifyPin(currentPin)) return false;
    return setupPin(newPin);
  }

  /// Verify a PIN
  bool verifyPin(String pin) {
    final storedHash = _prefs.getString(StorageKeys.pinHash);
    if (storedHash == null) return false;

    if (_verifyPinHash(pin, storedHash)) {
      _isAuthenticated = true;
      _isDecoyMode = false;
      return true;
    }

    // Check decoy PIN
    final decoyHash = _prefs.getString(StorageKeys.decoyPinHash);
    if (decoyHash != null && _verifyPinHash(pin, decoyHash)) {
      _isAuthenticated = true;
      _isDecoyMode = true;
      return true;
    }

    return false;
  }

  /// Remove PIN (requires current PIN verification)
  Future<bool> removePin(String currentPin) async {
    if (!verifyPin(currentPin)) return false;

    try {
      await _prefs.remove(StorageKeys.pinHash);
      await _prefs.remove(StorageKeys.decoyPinHash);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Remove decoy PIN
  Future<bool> removeDecoyPin() async {
    try {
      await _prefs.remove(StorageKeys.decoyPinHash);
      return true;
    } catch (e) {
      return false;
    }
  }

  // ============================================================================
  // Biometric Authentication
  // ============================================================================

  /// Check if biometrics are enabled
  bool get isBiometricEnabled =>
      _prefs.getBool(StorageKeys.biometricEnabled) ?? false;

  /// Check if biometrics are available on this device
  Future<bool> canUseBiometrics() async {
    if (!PlatformUtils.isMobile) return false;

    try {
      final canAuthenticate = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return canAuthenticate && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  /// Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    if (!PlatformUtils.isMobile) return [];

    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  /// Enable biometric authentication
  Future<bool> enableBiometrics() async {
    if (!await canUseBiometrics()) return false;

    try {
      await _prefs.setBool(StorageKeys.biometricEnabled, true);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Disable biometric authentication
  Future<void> disableBiometrics() async {
    await _prefs.setBool(StorageKeys.biometricEnabled, false);
  }

  /// Authenticate using biometrics
  Future<bool> authenticateWithBiometrics() async {
    if (!isBiometricEnabled || !await canUseBiometrics()) {
      return false;
    }

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to access Innerverse',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );

      if (authenticated) {
        _isAuthenticated = true;
        _isDecoyMode = false;
      }

      return authenticated;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Biometric authentication failed: $e',
        stackTrace: stack.toString(),
        type: ErrorType.security,
      );
      return false;
    }
  }

  // ============================================================================
  // Authentication Status
  // ============================================================================

  /// Check and update authentication status
  void checkAuthenticationStatus() {
    // For now, just maintain current state
    // Could add timeout logic here
  }

  /// Log out the user
  void logout() {
    _isAuthenticated = false;
    _isDecoyMode = false;
  }

  // ============================================================================
  // Dead Man's Switch
  // ============================================================================

  /// Update the last opened timestamp
  Future<void> updateLastOpened() async {
    await _prefs.setString(
      StorageKeys.lastOpenedAt,
      DateTime.now().toIso8601String(),
    );
  }

  /// Check if dead man's switch should trigger
  bool shouldTriggerDeadManSwitch() {
    final daysThreshold = _prefs.getInt(StorageKeys.deadManSwitchDays);
    if (daysThreshold == null) return false;

    final lastOpenedStr = _prefs.getString(StorageKeys.lastOpenedAt);
    if (lastOpenedStr == null) return false;

    try {
      final lastOpened = DateTime.parse(lastOpenedStr);
      final daysSinceLastOpened =
          DateTime.now().difference(lastOpened).inDays;
      return daysSinceLastOpened >= daysThreshold;
    } catch (e) {
      return false;
    }
  }

  /// Set dead man's switch days threshold
  Future<void> setDeadManSwitchDays(int? days) async {
    if (days == null) {
      await _prefs.remove(StorageKeys.deadManSwitchDays);
    } else {
      await _prefs.setInt(StorageKeys.deadManSwitchDays, days);
    }
  }

  // ============================================================================
  // Screenshot Blocking (Android only)
  // ============================================================================

  /// Check if screenshot blocking is enabled
  bool get isScreenshotBlockingEnabled =>
      _prefs.getBool(StorageKeys.screenshotBlockingEnabled) ?? false;

  /// Enable screenshot blocking
  Future<void> enableScreenshotBlocking() async {
    if (!PlatformUtils.isAndroid) return;

    try {
      await const MethodChannel('com.inner.verse/security')
          .invokeMethod('enableScreenshotBlocking');
      await _prefs.setBool(StorageKeys.screenshotBlockingEnabled, true);
    } catch (e) {
      debugPrint('Could not enable screenshot blocking: $e');
    }
  }

  /// Disable screenshot blocking
  Future<void> disableScreenshotBlocking() async {
    if (!PlatformUtils.isAndroid) return;

    try {
      await const MethodChannel('com.inner.verse/security')
          .invokeMethod('disableScreenshotBlocking');
      await _prefs.setBool(StorageKeys.screenshotBlockingEnabled, false);
    } catch (e) {
      debugPrint('Could not disable screenshot blocking: $e');
    }
  }

  // ============================================================================
  // Panic Button (Mobile only)
  // ============================================================================

  /// Trigger panic mode - shows innocent screen
  void triggerPanicMode() {
    if (!PlatformUtils.isMobile) return;

    _isAuthenticated = false;
    _isDecoyMode = true;
    // The UI should react to this state change and show innocent screen
  }

  // ============================================================================
  // Private Helpers
  // ============================================================================

  /// Hash a PIN using SHA-256 with a salt
  String _hashPin(String pin) {
    const salt = 'innerverse_secure_salt_2024';
    final bytes = utf8.encode('$salt$pin$salt');
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a PIN against a stored hash
  bool _verifyPinHash(String pin, String? storedHash) {
    if (storedHash == null) return false;
    return _hashPin(pin) == storedHash;
  }
}
