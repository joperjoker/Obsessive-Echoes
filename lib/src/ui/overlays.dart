import 'package:flutter/material.dart';
import '../game/audio_manager.dart';
import '../../core/game_config.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const GameOverOverlay({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'TOTAL ISOLATION',
              style: TextStyle(
                color: GameConfig.crimson,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Your echoes have faded into the silence.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                AudioManager.uiTap();
                onRestart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GameConfig.crimson,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('REAWAKEN'),
            ),
          ],
        ),
      ),
    );
  }
}

class VictoryOverlay extends StatelessWidget {
  final VoidCallback onRestart;

  const VictoryOverlay({super.key, required this.onRestart});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'HARMONY REACHED',
              style: TextStyle(
                color: GameConfig.vibrantBlue,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The echoes are finally at peace.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                AudioManager.uiTap();
                onRestart();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GameConfig.vibrantBlue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              ),
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      ),
    );
  }
}
