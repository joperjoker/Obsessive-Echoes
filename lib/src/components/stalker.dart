import 'dart:math' as math;
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';
import '../game/effect_manager.dart';
import 'player.dart';

class Stalker extends PositionComponent with HasGameReference<VoidOfEchoesGame>, CollisionCallbacks {
  final double speed = 260.0;
  static const double sizeVal = 35.0;
  
  Stalker({required Vector2 position}) : super(
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
    
    // Slight oscillation to feel "twitchy"
    angle = math.sin(game.currentTime() * 10) * 0.1;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
      EffectManager.spawnHitEffect(game, position);
      Future.microtask(() {
        game.notifier.updateIdentity(-8.0);
        AudioManager.playHit();
      });
    }
  }

  @override
  void render(Canvas canvas) {
    final paint = Paint()..color = GameConfig.crimson.withValues(alpha: 0.9);
    // Draw a diamond shape
    final path = Path()
      ..moveTo(sizeVal / 2, 0)
      ..lineTo(sizeVal, sizeVal / 2)
      ..lineTo(sizeVal / 2, sizeVal)
      ..lineTo(0, sizeVal / 2)
      ..close();
    canvas.drawPath(path, paint);
  }
}
