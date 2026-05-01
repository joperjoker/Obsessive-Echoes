import 'dart:ui';
import 'dart:math';
import 'package:flame/components.dart';
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';
import '../game/audio_manager.dart';

class Enemy extends PositionComponent with HasGameRef<VoidOfEchoesGame> {
  final double speed = 150.0;
  static const double radius = 25.0;
  
  Enemy({required Vector2 position}) : super(
    position: position,
    size: Vector2.all(radius * 2),
    anchor: Anchor.center,
  );

  @override
  void update(double dt) {
    // Move towards player
    final dir = (gameRef.player.position - position).normalized();
    position += dir * speed * dt;

    // Simple collision check
    if (position.distanceTo(gameRef.player.position) < radius + 30.0) {
      removeFromParent();
      Future.microtask(() {
        gameRef.notifier.updateIdentity(-10.0);
        AudioManager.playHit();
      });
    }
  }

  @override
  void render(Canvas canvas) {
    canvas.drawRect(
      Rect.fromLTWH(0, 0, radius * 2, radius * 2),
      Paint()..color = GameConfig.crimson,
    );
  }
}
