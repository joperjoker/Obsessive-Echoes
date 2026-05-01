import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/collisions.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/game_config.dart';
import '../game/void_of_echoes_game.dart';

class Player extends PositionComponent with HasGameRef<VoidOfEchoesGame>, CollisionCallbacks {
  static const double speed = 400.0;
  static const double radius = 30.0;
  
  late Paint _paint;

  Player() : super(
    size: Vector2.all(radius * 2),
    anchor: Anchor.center,
  );

  @override
  void onLoad() {
    position = Vector2(GameConfig.arenaWidth / 2, GameConfig.arenaHeight / 2);
    _paint = Paint()
      ..color = GameConfig.vibrantBlue
      ..maskFilter = const MaskFilter.blur(BlurStyle.outer, 10.0);
      
    add(CircleHitbox(radius: radius));
  }

  @override
  void update(double dt) {
    if (gameRef.moveDir != Vector2.zero()) {
      position += gameRef.moveDir * speed * dt;
    }

    position.x = position.x.clamp(radius, GameConfig.arenaWidth - radius);
    position.y = position.y.clamp(radius, GameConfig.arenaHeight - radius);
  }

  @override
  void render(Canvas canvas) {
    canvas.drawCircle(Offset(radius, radius), radius, Paint()..color = GameConfig.vibrantBlue);
    canvas.drawCircle(Offset(radius, radius), radius, _paint);
    canvas.drawCircle(Offset(radius, radius), radius * 0.5, Paint()..color = Colors.white.withOpacity(0.5));
  }
}
