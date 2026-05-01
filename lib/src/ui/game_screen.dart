import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flame/game.dart';
import '../game/void_of_echoes_game.dart';
import '../game/game_state.dart';
import 'hud.dart';
import 'overlays.dart';
import 'dialogue_overlay.dart';

class GameScreen extends ConsumerStatefulWidget {
  const GameScreen({super.key});

  @override
  ConsumerState<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends ConsumerState<GameScreen> {
  late VoidOfEchoesGame _game;

  @override
  void initState() {
    super.initState();
    _game = VoidOfEchoesGame(notifier: ref.read(gameStateProvider.notifier));
  }

  @override
  Widget build(BuildContext context) {
    final gameState = ref.watch(gameStateProvider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GameWidget(game: _game),
          const Hud(),
          const DialogueOverlay(),
          if (gameState.isGameOver) GameOverOverlay(onRestart: _game.resetGame),
          if (gameState.isVictory) VictoryOverlay(onRestart: _game.resetGame),
        ],
      ),
    );
  }
}
