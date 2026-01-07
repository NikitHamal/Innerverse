/// Audio service for ambient sounds in Innerverse
library;

import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

import '../core/constants/app_constants.dart';
import '../core/constants/space_configs.dart';
import '../core/errors/error_handler.dart';

/// Audio service for managing ambient sounds and sound effects
class AudioService {
  AudioPlayer? _ambientPlayer;
  AudioPlayer? _effectPlayer;

  String? _currentSpaceId;
  bool _wasPlayingBeforeBackground = false;
  bool _isInitialized = false;
  double _ambientVolume = 0.5;
  bool _isAmbientEnabled = true;

  /// Whether the service is initialized
  bool get isInitialized => _isInitialized;

  /// Whether ambient sound is currently playing
  bool get isPlaying => _ambientPlayer?.playing ?? false;

  /// Current ambient volume (0.0 - 1.0)
  double get ambientVolume => _ambientVolume;

  /// Current playing space ID
  String? get currentSpaceId => _currentSpaceId;

  /// Initialize the audio service
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      _ambientPlayer = AudioPlayer();
      _effectPlayer = AudioPlayer();

      // Configure ambient player for looping
      await _ambientPlayer?.setLoopMode(LoopMode.one);
      await _ambientPlayer?.setVolume(_ambientVolume);

      // Configure effect player
      await _effectPlayer?.setVolume(0.7);

      _isInitialized = true;
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Failed to initialize audio service: $e',
        stackTrace: stack.toString(),
        type: ErrorType.audio,
      );
    }
  }

  /// Set whether ambient sounds are enabled
  void setAmbientEnabled(bool enabled) {
    _isAmbientEnabled = enabled;
    if (!enabled) {
      stopAmbient();
    }
  }

  /// Set the ambient volume
  Future<void> setAmbientVolume(double volume) async {
    _ambientVolume = volume.clamp(0.0, 1.0);
    await _ambientPlayer?.setVolume(_ambientVolume);
  }

  /// Play ambient sound for a space
  Future<void> playAmbientForSpace(String spaceId) async {
    if (!_isInitialized || !_isAmbientEnabled) return;
    if (_currentSpaceId == spaceId && isPlaying) return;

    try {
      final config = getSpaceConfig(spaceId);
      final audioPath = config.audioAsset;

      // Stop current ambient if different space
      if (_currentSpaceId != spaceId) {
        await _fadeOut();
      }

      _currentSpaceId = spaceId;

      // Load and play the new ambient
      await _ambientPlayer?.setAsset(audioPath);
      await _ambientPlayer?.setVolume(0);
      await _ambientPlayer?.play();
      await _fadeIn();
    } catch (e, stack) {
      ErrorHandler.instance.logError(
        message: 'Failed to play ambient for space $spaceId: $e',
        stackTrace: stack.toString(),
        type: ErrorType.audio,
      );
    }
  }

  /// Stop ambient sound with fade out
  Future<void> stopAmbient() async {
    if (!_isInitialized) return;

    try {
      await _fadeOut();
      await _ambientPlayer?.stop();
      _currentSpaceId = null;
    } catch (e) {
      debugPrint('Error stopping ambient: $e');
    }
  }

  /// Pause ambient for app going to background
  Future<void> pauseForBackground() async {
    _wasPlayingBeforeBackground = isPlaying;
    if (isPlaying) {
      await _ambientPlayer?.pause();
    }
  }

  /// Resume ambient if it was playing before background
  Future<void> resumeIfWasPlaying() async {
    if (_wasPlayingBeforeBackground && _isAmbientEnabled) {
      await _ambientPlayer?.play();
    }
    _wasPlayingBeforeBackground = false;
  }

  /// Play a sound effect
  Future<void> playEffect(SoundEffect effect) async {
    if (!_isInitialized) return;

    try {
      final path = _getEffectPath(effect);
      await _effectPlayer?.setAsset(path);
      await _effectPlayer?.play();
    } catch (e) {
      debugPrint('Error playing effect: $e');
    }
  }

  /// Play typing sound
  Future<void> playTypingSound() async {
    await playEffect(SoundEffect.typing);
  }

  /// Play message sent sound
  Future<void> playMessageSentSound() async {
    await playEffect(SoundEffect.messageSent);
  }

  /// Play capsule unlock sound
  Future<void> playCapsuleUnlockSound() async {
    await playEffect(SoundEffect.capsuleUnlock);
  }

  /// Play burn effect sound
  Future<void> playBurnEffectSound() async {
    await playEffect(SoundEffect.burnEffect);
  }

  /// Fade in the ambient player
  Future<void> _fadeIn() async {
    if (_ambientPlayer == null) return;

    const steps = 10;
    final stepDuration = AppDurations.slow.inMilliseconds ~/ steps;
    final stepVolume = _ambientVolume / steps;

    for (var i = 1; i <= steps; i++) {
      await Future.delayed(Duration(milliseconds: stepDuration));
      await _ambientPlayer?.setVolume(stepVolume * i);
    }
  }

  /// Fade out the ambient player
  Future<void> _fadeOut() async {
    if (_ambientPlayer == null || !isPlaying) return;

    const steps = 10;
    final stepDuration = AppDurations.normal.inMilliseconds ~/ steps;
    final currentVolume = _ambientPlayer!.volume;
    final stepVolume = currentVolume / steps;

    for (var i = steps - 1; i >= 0; i--) {
      await Future.delayed(Duration(milliseconds: stepDuration));
      await _ambientPlayer?.setVolume(stepVolume * i);
    }
  }

  /// Get the asset path for a sound effect
  String _getEffectPath(SoundEffect effect) {
    return switch (effect) {
      SoundEffect.typing => AssetPaths.typingSoft,
      SoundEffect.messageSent => AssetPaths.messageSent,
      SoundEffect.capsuleUnlock => AssetPaths.capsuleUnlock,
      SoundEffect.burnEffect => AssetPaths.burnEffect,
    };
  }

  /// Dispose of the audio service
  Future<void> dispose() async {
    await _ambientPlayer?.dispose();
    await _effectPlayer?.dispose();
    _ambientPlayer = null;
    _effectPlayer = null;
    _isInitialized = false;
  }
}

/// Sound effects available in the app
enum SoundEffect {
  typing,
  messageSent,
  capsuleUnlock,
  burnEffect,
}
