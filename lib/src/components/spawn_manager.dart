import 'dart:math' as math;
import 'package:flame/components.dart';
import '../game/void_of_echoes_game.dart';
import '../../core/game_config.dart';
import 'enemy.dart';
import 'fragment.dart';

class SpawnManager extends Component with HasGameReference<VoidOfEchoesGame> {
  final math.Random _random = math.Random();
  
  double _enemySpawnTimer = 0;
  double _fragmentSpawnTimer = 0;
  double _elapsedTime = 0;
  
  // Difficulty scaling
  final double _baseEnemySpawnInterval = 2.0;
  final double _minEnemySpawnInterval = 0.5;
  final double _difficultyScale = 0.05; // Decrease interval by this much every 10 seconds

  @override
  void update(double dt) {
    if (game.gameState.isGameOver || game.gameState.isVictory) return;

    _enemySpawnTimer += dt;
    _fragmentSpawnTimer += dt;
    _elapsedTime += dt;

    // Scale difficulty
    final currentEnemyInterval = (_baseEnemySpawnInterval - (_elapsedTime / 10.0) * _difficultyScale).clamp(_minEnemySpawnInterval, _baseEnemySpawnInterval);

    if (_enemySpawnTimer > currentEnemyInterval) {
      _enemySpawnTimer = 0;
      _spawnEnemy();
    }

    if (_fragmentSpawnTimer > 1.5) {
      _fragmentSpawnTimer = 0;
      _spawnFragment();
    }
  }

  void _spawnEnemy() {
    final side = _random.nextInt(4);
    Vector2 pos;
    switch (side) {
      case 0: pos = Vector2(_random.nextDouble() * GameConfig.arenaWidth, -50); break;
      case 1: pos = Vector2(GameConfig.arenaWidth + 50, _random.nextDouble() * GameConfig.arenaHeight); break;
      case 2: pos = Vector2(_random.nextDouble() * GameConfig.arenaWidth, GameConfig.arenaHeight + 50); break;
      default: pos = Vector2(-50, _random.nextDouble() * GameConfig.arenaHeight); break;
    }
    game.world.add(Enemy(position: pos));
  }

  void _spawnFragment() {
    final pos = Vector2(
      100 + _random.nextDouble() * (GameConfig.arenaWidth - 200),
      100 + _random.nextDouble() * (GameConfig.arenaHeight - 200),
    );
    game.world.add(Fragment(position: pos));
  }
}
