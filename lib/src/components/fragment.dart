import 'dart:ui';
import 'package:flame/components.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';

class Fragment extends PositionComponent with HasGameRef<VoidOfEchoesGame> {
  static const double radius = 15.0;

  Fragment({required Vector2 position}) : super(
    position: position,
    size: Vector2.all(radius * 2),
    anchor: Anchor.center,
  );

  @override
  void update(double dt) {
    if (position.distanceTo(gameRef.player.position) < radius + 30.0) {
      removeFromParent();
      Future.microtask(() {
        gameRef.notifier.addScore(10);
        gameRef.notifier.updateIdentity(5.0);
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
  }
}
