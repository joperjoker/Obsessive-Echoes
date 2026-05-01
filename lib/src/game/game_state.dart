import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameState {
  final int score;
  final double identity;
  final bool isGameOver;
  final bool isVictory;
  final int stage;

  GameState({
    this.score = 0,
    this.identity = 100.0,
    this.isGameOver = false,
    this.isVictory = false,
    this.stage = 1,
  });

  GameState copyWith({
    int? score,
    double? identity,
    bool? isGameOver,
    bool? isVictory,
    int? stage,
  }) {
    return GameState(
      score: score ?? this.score,
      identity: identity ?? this.identity,
      isGameOver: isGameOver ?? this.isGameOver,
      isVictory: isVictory ?? this.isVictory,
      stage: stage ?? this.stage,
    );
  }
}

class GameStateNotifier extends StateNotifier<GameState> {
  GameStateNotifier() : super(GameState());

  void addScore(int points) {
    state = state.copyWith(score: state.score + points);
  }

  void updateIdentity(double delta) {
    final newIdentity = (state.identity + delta).clamp(0.0, 100.0);
    state = state.copyWith(identity: newIdentity);
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

  void reset() {
    state = GameState();
  }
}

final gameStateProvider = StateNotifierProvider<GameStateNotifier, GameState>((ref) {
  return GameStateNotifier();
});
