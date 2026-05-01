import 'package:flame/components.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'void_of_echoes_game.dart';
import '../../core/game_config.dart';

class EffectManager {
  static void spawnCollectionEffect(VoidOfEchoesGame game, Vector2 position) {
    HapticFeedback.lightImpact();
    game.world.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 8,
          lifespan: 0.6,
          generator: (i) => AcceleratedParticle(
            acceleration: Vector2(0, 50),
            speed: Vector2.random() * 100,
            child: CircleParticle(
              radius: 2.0,
              paint: Paint()..color = GameConfig.vibrantBlue.withValues(alpha: 0.8),
            ),
          ),
        ),
      ),
    );
  }

  static void spawnHitEffect(VoidOfEchoesGame game, Vector2 position) {
    HapticFeedback.heavyImpact();
    // Simplified shake: tiny offset on viewfinder
    game.camera.viewfinder.position += Vector2(5, 5);
    Future.delayed(const Duration(milliseconds: 50), () {
      game.camera.viewfinder.position -= Vector2(5, 5);
    });

    game.world.add(
      ParticleSystemComponent(
        position: position,
        particle: Particle.generate(
          count: 12,
          lifespan: 0.4,
          generator: (i) => AcceleratedParticle(
            speed: Vector2.random() * 200,
            child: CircleParticle(
              radius: 3.0,
              paint: Paint()..color = GameConfig.crimson,
            ),
          ),
        ),
      ),
    );
  }
}
