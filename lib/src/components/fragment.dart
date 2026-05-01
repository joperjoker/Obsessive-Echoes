import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';
import 'player.dart';

class Fragment extends PositionComponent with HasGameRef<VoidOfEchoesGame>, CollisionCallbacks {
  static const double radius = 15.0;

  Fragment({required Vector2 position}) : super(
    position: position,
    size: Vector2.all(radius * 2),
    anchor: Anchor.center,
  );

  @override
  void onLoad() {
    add(CircleHitbox());
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Player) {
      removeFromParent();
      Future.microtask(() {
        gameRef.notifier.addScore(10);
        gameRef.notifier.updateIdentity(8.0);
        AudioManager.playCollect();
      });
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(
      Offset(radius, radius),
      radius,
      Paint()..color = GameConfig.vibrantBlue.withOpacity(0.8),
    );
    // Add a small white "spark" in the center
    canvas.drawCircle(
      Offset(radius, radius),
      radius * 0.3,
      Paint()..color = Color.from(alpha: 1, blue: 1, green: 1, red: 1),
    );
  }
}
