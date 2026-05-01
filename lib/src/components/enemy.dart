import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';
import 'player.dart';

class Enemy extends PositionComponent with HasGameRef<VoidOfEchoesGame>, CollisionCallbacks {
  final double speed = 150.0;
  static const double sizeVal = 50.0;
  
  Enemy({required Vector2 position}) : super(
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
    if (gameRef.notifier.state.isGameOver) return;
    
    final dir = (gameRef.player.position - position).normalized();
    position += dir * speed * dt;
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
      Future.microtask(() {
        gameRef.notifier.updateIdentity(-15.0);
        AudioManager.playHit();
      });
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, sizeVal, sizeVal),
      Paint()..color = GameConfig.crimson,
    );
    // Draw a dark center to give it more character
    canvas.drawRect(
      Rect.fromLTWH(sizeVal * 0.25, sizeVal * 0.25, sizeVal * 0.5, sizeVal * 0.5),
      Paint()..color = GameConfig.background,
    );
  }
}
