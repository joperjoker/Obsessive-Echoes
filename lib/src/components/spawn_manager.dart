import 'dart:math' as math;
import 'package:flame/components.dart';
import '../game/void_of_echoes_game.dart';
import '../../core/game_config.dart';
import 'enemy.dart';
import 'stalker.dart';
import 'void_enemy.dart';
import 'fragment.dart';

class SpawnManager extends Component with HasGameReference<VoidOfEchoesGame> {
  final math.Random _random = math.Random();
  
  double _enemySpawnTimer = 0;
  double _fragmentSpawnTimer = 0;
  double _elapsedTime = 0;
  
  final double _baseEnemySpawnInterval = 2.0;
  final double _minEnemySpawnInterval = 0.4;
  final double _difficultyScale = 0.05;

  @override
  void update(double dt) {
    if (game.gameState.isGameOver || game.gameState.isVictory) return;

    _enemySpawnTimer += dt;
    _fragmentSpawnTimer += dt;
    _elapsedTime += dt;

    final currentEnemyInterval = (_baseEnemySpawnInterval - (_elapsedTime / 10.0) * _difficultyScale).clamp(_minEnemySpawnInterval, _baseEnemySpawnInterval);

    if (_enemySpawnTimer > currentEnemyInterval) {
      _enemySpawnTimer = 0;
      _spawnRandomEnemy();
    }

    if (_fragmentSpawnTimer > 1.5) {
      _fragmentSpawnTimer = 0;
      _spawnFragment();
    }
  }

  void _spawnRandomEnemy() {
    final roll = _random.nextDouble();
    PositionComponent enemy;
    
    // Weighted spawn based on time
    if (_elapsedTime > 60 && roll < 0.15) {
      enemy = VoidEnemy(position: _getRandomEdgePosition());
    } else if (_elapsedTime > 30 && roll < 0.4) {
      enemy = Stalker(position: _getRandomEdgePosition());
    } else {
      enemy = Enemy(position: _getRandomEdgePosition());
    }
    
    game.world.add(enemy);
  }

  Vector2 _getRandomEdgePosition() {
    final side = _random.nextInt(4);
    switch (side) {
      case 0: return Vector2(_random.nextDouble() * GameConfig.arenaWidth, -100);
      case 1: return Vector2(GameConfig.arenaWidth + 100, _random.nextDouble() * GameConfig.arenaHeight);
      case 2: return Vector2(_random.nextDouble() * GameConfig.arenaWidth, GameConfig.arenaHeight + 100);
      default: return Vector2(-100, _random.nextDouble() * GameConfig.arenaHeight);
    }
  }

  void _spawnFragment() {
    final pos = Vector2(
      100 + _random.nextDouble() * (GameConfig.arenaWidth - 200),
      100 + _random.nextDouble() * (GameConfig.arenaHeight - 200),
    );
    game.world.add(Fragment(position: pos));
  }
}
