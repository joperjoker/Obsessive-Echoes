import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart' show Colors;
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';
import '../game/effect_manager.dart';
import 'player.dart';

class VoidEnemy extends PositionComponent with HasGameReference<VoidOfEchoesGame>, CollisionCallbacks {
  final double speed = 90.0;
  static const double sizeVal = 80.0;
  
  VoidEnemy({required Vector2 position}) : super(
    position: position,
    size: Vector2.all(sizeVal),
    anchor: Anchor.center,
  );

  @override
  void onLoad() {
    add(RectangleHitbox());
  }

  @override
  void update(double dt) {
    if (game.gameState.isGameOver) return;
    
    final dir = (game.player.position - position).normalized();
    position += dir * speed * dt;
    
    // Slow pulsing size
    final scaleVal = 1.0 + math.sin(game.currentTime() * 2) * 0.1;
    scale = Vector2.all(scaleVal);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
      EffectManager.spawnHitEffect(game, position);
      Future.microtask(() {
        game.notifier.updateIdentity(-30.0); // Heavy hitter
        AudioManager.playHit();
      });
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = GameConfig.crimson.withValues(alpha: 0.6);
    canvas.drawCircle(Offset(sizeVal / 2, sizeVal / 2), sizeVal / 2, paint);
    
    // Inner core
    final corePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(sizeVal / 2, sizeVal / 2), sizeVal / 4, corePaint);
  }
}
