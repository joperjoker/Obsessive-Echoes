import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'audio_manager.dart';

class GameState {
  final int score;
  final double identity;
  final bool isGameOver;
  final bool isVictory;
  final int stage;
  final String dialogue;

  GameState({
    this.score = 0,
    this.identity = 100.0,
    this.isGameOver = false,
    this.isVictory = false,
    this.stage = 1,
    this.dialogue = "",
  });

  factory GameState.initial() => GameState();

  GameState copyWith({
    int? score,
    double? identity,
    bool? isGameOver,
    bool? isVictory,
    int? stage,
    String? dialogue,
  }) {
    return GameState(
      score: score ?? this.score,
      identity: identity ?? this.identity,
      isGameOver: isGameOver ?? this.isGameOver,
      isVictory: isVictory ?? this.isVictory,
      stage: stage ?? this.stage,
      dialogue: dialogue ?? this.dialogue,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState.initial());

  GameState get currentState => state;

  void addScore(int points) {
    final newScore = state.score + points;
    state = state.copyWith(score: newScore);
    
    // Stage Transitions
    if (state.stage == 1 && newScore >= 200) {
      nextStage();
      updateDialogue("The echoes are getting louder... I must persist.");
    } else if (state.stage == 2 && newScore >= 500) {
      nextStage();
      updateDialogue("Is there an end to this void? Or is it just me?");
    } else if (state.stage == 3 && newScore >= 1000) {
      triggerVictory();
    }
  }

  void updateIdentity(double delta) {
    final newIdentity = (state.identity + delta).clamp(0.0, 100.0);
    state = state.copyWith(identity: newIdentity);
    
    if (newIdentity <= 30 && newIdentity > 0) {
      AudioManager.startHeartbeat();
    } else {
      AudioManager.stopHeartbeat();
    }

    if (newIdentity <= 0) {
      triggerGameOver();
    }
  }

  void triggerGameOver() {
    state = state.copyWith(isGameOver: true);
  }

  void triggerVictory() {
    state = state.copyWith(isVictory: true);
  }

  void nextStage() {
    state = state.copyWith(stage: state.stage + 1);
  }

  void updateDialogue(String message) {
    state = state.copyWith(dialogue: message);
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted && state.dialogue == message) {
        state = state.copyWith(dialogue: "");
      }
    });
  }

  void reset() {
    state = GameState();
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});
