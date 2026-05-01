import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../game/game_state.dart';
import '../../core/game_config.dart';

class DialogueOverlay extends ConsumerWidget {
  const DialogueOverlay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dialogue = ref.watch(gameStateProvider.select((s) => s.dialogue));
    
    if (dialogue.isEmpty) return const SizedBox.shrink();

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          decoration: BoxDecoration(
            color: Colors.black.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: GameConfig.vibrantBlue.withValues(alpha: 0.5)),
          ),
          child: Text(
            dialogue,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontStyle: FontStyle.italic,
              letterSpacing: 0.5,
              shadows: [Shadow(color: GameConfig.vibrantBlue, blurRadius: 10)],
            ),
          ),
        ),
      ),
    );
  }
}
