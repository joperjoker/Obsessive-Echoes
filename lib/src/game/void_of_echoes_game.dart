import 'dart:ui';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' show Colors;
import '../../core/game_config.dart';
import 'game_state.dart';
import 'audio_manager.dart';
import '../components/player.dart';
import '../components/spawn_manager.dart';
import '../components/background_grid.dart';

class VoidOfEchoesGame extends FlameGame with DragCallbacks, HasCollisionDetection {
  final GameStateNotifier notifier;
  
  late Player player;
  
  Vector2 moveDir = Vector2.zero();
  Vector2? _joystickAnchor;
  Vector2? _joystickCurrent;
  final double _joystickRadius = 90.0;
  final double _deadzone = 8.0;

  VoidOfEchoesGame({required this.notifier}) : super(
    camera: CameraComponent.withFixedResolution(
      width: GameConfig.arenaWidth,
      height: GameConfig.arenaHeight,
    ),
  );

  GameState get gameState => notifier.currentState;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    camera.viewfinder.position = Vector2.zero();
    
    await AudioManager.init();
    AudioManager.playBGM();

    world.add(BackgroundGrid());
    player = Player();
    world.add(player);
    world.add(SpawnManager());
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    _joystickAnchor = event.localPosition.clone();
    _joystickCurrent = event.localPosition.clone();
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);
    if (_joystickAnchor == null || _joystickCurrent == null) return;
    
    _joystickCurrent!.add(event.localDelta);
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
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
  }

  @override
  void onDragCancel(DragCancelEvent event) {
    super.onDragCancel(event);
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    
    if (_joystickAnchor != null && _joystickCurrent != null) {
      final paint = Paint()..color = Colors.white.withValues(alpha: 0.3);
      canvas.drawCircle(_joystickAnchor!.toOffset(), _joystickRadius, paint);
      
      final innerPaint = Paint()..color = Colors.white.withValues(alpha: 0.5);
      final innerPos = _joystickAnchor! + (moveDir * (_joystickCurrent! - _joystickAnchor!).length.clamp(0.0, _joystickRadius));
      canvas.drawCircle(innerPos.toOffset(), 40.0, innerPaint);
    }
  }

  void resetGame() {
    _joystickAnchor = null;
    _joystickCurrent = null;
    moveDir = Vector2.zero();
    
    // Clear the world children and re-add essentials
    world.children.where((c) => c is! CameraComponent).forEach((c) => c.removeFromParent());
    
    world.add(BackgroundGrid());
    player = Player();
    world.add(player);
    world.add(SpawnManager());
    
    notifier.reset();
    AudioManager.playBGM();
  }
}
