import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/game_config.dart';
import 'game_state.dart';
import 'audio_manager.dart';
import '../components/player.dart';
import '../components/enemy.dart';
import '../components/fragment.dart';
import 'dart:math' as math;

class VoidOfEchoesGame extends FlameGame with PanDetector {
  final GameStateNotifier notifier;
  
  late Player player;
  
  Vector2 moveDir = Vector2.zero();
  Vector2? _joystickAnchor;
  Vector2? _joystickCurrent;
  final double _joystickRadius = 90.0;
  final double _deadzone = 8.0;
  
  double _spawnTimer = 0;
  double _fragmentTimer = 0;
  final math.Random _random = math.Random();

  VoidOfEchoesGame({required this.notifier}) : super(
    camera: CameraComponent.withFixedResolution(
      width: GameConfig.arenaWidth,
      height: GameConfig.arenaHeight,
    ),
  );

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2.zero();
    
    await AudioManager.init();
    AudioManager.playBGM();

    player = Player();
    world.add(player);
  }

  @override
  void onPanStart(DragStartInfo info) {
    _joystickAnchor = info.eventPosition.global.clone();
    _joystickCurrent = info.eventPosition.global.clone();
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (_joystickAnchor == null) return;
    
    _joystickCurrent = info.eventPosition.global.clone();
    final delta = _joystickCurrent! - _joystickAnchor!;
    
    if (delta.length > _joystickRadius) {
      _joystickAnchor!.add(delta.normalized() * (delta.length - _joystickRadius));
    }
    
    if (delta.length > _deadzone) {
      moveDir = delta.normalized();
    } else {
      moveDir = Vector2.zero();
    }
  }

  @override
  void onPanEnd(DragEndInfo info) {
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
  }

  @override
  void onPanCancel() {
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    // Draw Virtual Joystick
    if (_joystickAnchor != null && _joystickCurrent != null) {
      final paint = Paint()..color = Colors.white.withOpacity(0.3);
      canvas.drawCircle(_joystickAnchor!.toOffset(), _joystickRadius, paint);
      
      final innerPaint = Paint()..color = Colors.white.withOpacity(0.5);
      final innerPos = _joystickAnchor! + (moveDir * (_joystickCurrent! - _joystickAnchor!).length.clamp(0.0, _joystickRadius));
      canvas.drawCircle(innerPos.toOffset(), 40.0, innerPaint);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (notifier.state.isGameOver || notifier.state.isVictory) return;

    _spawnTimer += dt;
    _fragmentTimer += dt;

    if (_spawnTimer > 2.0) {
      _spawnTimer = 0;
      _spawnEnemy();
    }

    if (_fragmentTimer > 1.5) {
      _fragmentTimer = 0;
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
    world.add(Enemy(position: pos));
  }

  void _spawnFragment() {
    final pos = Vector2(
      50 + _random.nextDouble() * (GameConfig.arenaWidth - 100),
      50 + _random.nextDouble() * (GameConfig.arenaHeight - 100),
    );
    world.add(Fragment(position: pos));
  }

  void resetGame() {
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
    _spawnTimer = 0;
    _fragmentTimer = 0;
    
    // Remove transient world children
    world.children.whereType<Enemy>().forEach((e) => e.removeFromParent());
    world.children.whereType<Fragment>().forEach((f) => f.removeFromParent());
    
    player.position = Vector2(GameConfig.arenaWidth / 2, GameConfig.arenaHeight / 2);
    
    notifier.reset();
    AudioManager.playBGM();
  }
}
