import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/services.dart';

class AudioManager {
  static bool _ready = false;

  static Future<void> init() async {
    if (_ready) return;
    try {
      await FlameAudio.audioCache.loadAll([
        'sfx_hit.mp3',
        'sfx_collect.mp3',
        'sfx_boss.mp3',
        'bgm_main.mp3',
      ]);
      _ready = true;
    } catch (e) {
      // Keep gameplay alive even if audio fails
      debugPrint('Audio initialization failed: $e');
    }
  }

  static void playBGM() {
    if (!_ready) return;
    try {
      FlameAudio.bgm.play('bgm_main.mp3', volume: 0.4);
    } catch (_) {}
  }

  static void stopBGM() {
    try {
      FlameAudio.bgm.stop();
    } catch (_) {}
  }

  static void playHit() {
    if (_ready) {
      try {
        FlameAudio.play('sfx_hit.mp3');
      } catch (_) {}
    }
    HapticFeedback.heavyImpact();
  }

  static void playCollect() {
    if (_ready) {
      try {
        FlameAudio.play('sfx_collect.mp3');
      } catch (_) {}
    }
    HapticFeedback.selectionClick();
  }

  static void playBossCue() {
    if (_ready) {
      try {
        FlameAudio.play('sfx_boss.mp3');
      } catch (_) {}
    }
    HapticFeedback.mediumImpact();
  }

  static void uiTap() => HapticFeedback.lightImpact();
}
