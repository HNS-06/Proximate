import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SoundManager {
  static final AudioPlayer _player = AudioPlayer();
  static bool _muted = false;

  static Future<void> init() async {
    await _player.setReleaseMode(ReleaseMode.stop);
    try {
      final prefs = await SharedPreferences.getInstance();
      _muted = prefs.getBool('sound_muted') ?? false;
    } catch (e) {
      print('Failed to load sound prefs: $e');
    }
  }

  /// Play the startup/opening sound regardless of mute state.
  static Future<void> playStartup() async {
    try {
      // Try a dedicated startup sound first, fallback to notification
      await _player.stop();
      await _player.play(AssetSource('sounds/core/startup.wav'));
    } catch (e) {
      try {
        await _player.play(AssetSource('sounds/core/notification.wav'));
      } catch (e2) {
        print('Startup sound failed: $e / $e2');
      }
    }
  }

  /// Generic play method with category support
  static Future<void> play(String soundFile, {String category = 'core'}) async {
    if (_muted) return;
    
    try {
      await _player.stop();
      final soundPath = 'sounds/$category/$soundFile';
      await _player.play(AssetSource(soundPath));
    } catch (e) {
      print('Error playing sound $soundFile from $category: $e');
      // Fallback to notification sound
      _playFallback();
    }
  }

  /// Fallback to notification sound
  static Future<void> _playFallback() async {
    try {
      await _player.play(AssetSource('sounds/core/notification.wav'));
    } catch (e) {
      print('Fallback sound also failed: $e');
    }
  }

  /// ----------------- CORE SOUNDS (You have these) -----------------
  static Future<void> playConnect() => play('connect.wav');
  static Future<void> playScan() => play('scan.wav');
  static Future<void> playMatch() => play('match.wav');
  static Future<void> playNotification() => play('notification.wav');
  static Future<void> playEncrypt() => play('encrypt.wav');

  /// ----------------- UI SOUNDS (You have these) -----------------
  static Future<void> playSuccess() => play('success.wav', category: 'ui');
  static Future<void> playError() => play('error.wav', category: 'ui');
  static Future<void> playButtonClick() => play('button_click.wav', category: 'ui');
  
  /// ----------------- QR SOUNDS (You have this) -----------------
  static Future<void> playQRScan() => play('qr_scan.wav', category: 'qr');

  /// ----------------- TEAM SOUNDS (You have this) -----------------
  static Future<void> playTeamJoin() => play('team_join.wav', category: 'team');

  /// ----------------- UTILITY METHODS -----------------
  static Future<void> toggleMute() async {
    _muted = !_muted;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('sound_muted', _muted);
    } catch (e) {
      print('Failed to save sound prefs: $e');
    }
  }

  static bool get isMuted => _muted;

  /// Test all available sounds (for development)
  static Future<void> testAllSounds() async {
    print('Testing all available sounds...');
    
    final sounds = [
      ('Connect', playConnect),
      ('Scan', playScan),
      ('Match', playMatch),
      ('Notification', playNotification),
      ('Encrypt', playEncrypt),
      ('Success', playSuccess),
      ('Error', playError),
      ('Button Click', playButtonClick),
      ('QR Scan', playQRScan),
      ('Team Join', playTeamJoin),
    ];

    for (int i = 0; i < sounds.length; i++) {
      final (name, soundFunc) = sounds[i];
      print('Playing sound ${i + 1}/${sounds.length}: $name');
      await soundFunc();
      await Future.delayed(const Duration(milliseconds: 500));
    }
    
    print('Sound test complete!');
  }

  /// Check if a sound file exists (for debugging)
  static Future<bool> checkSoundExists(String soundFile, {String category = 'core'}) async {
    try {
      // Try to load the sound
      await _player.setSource(AssetSource('sounds/$category/$soundFile'));
      return true;
    } catch (e) {
      print('Sound check failed for $category/$soundFile: $e');
      return false;
    }
  }

  /// Preload frequently used sounds
  static Future<void> preloadSounds() async {
    print('Preloading sounds...');
    
    // List of sounds you actually have
    final availableSounds = [
      'sounds/core/connect.wav',
      'sounds/core/notification.wav',
      'sounds/ui/button_click.wav',
      'sounds/ui/success.wav',
    ];

    for (final soundPath in availableSounds) {
      try {
        await _player.setSource(AssetSource(soundPath));
        await Future.delayed(const Duration(milliseconds: 50));
        print('Preloaded: $soundPath');
      } catch (e) {
        print('Failed to preload $soundPath: $e');
      }
    }
    
    print('Preloading complete!');
  }

  /// Set volume (0.0 to 1.0)
  static Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Play sound with specific volume
  static Future<void> playWithVolume(String soundFile, double volume, {String category = 'core'}) async {
    if (_muted) return;
    
    final currentVolume = _player.volume;
    await setVolume(volume);
    await play(soundFile, category: category);
    await setVolume(currentVolume);
  }

  /// Get current volume
  static double get volume => _player.volume;

  /// Dispose resources
  static Future<void> dispose() async {
    await _player.dispose();
  }
}