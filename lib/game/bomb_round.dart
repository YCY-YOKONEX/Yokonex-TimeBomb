enum BombPhase { ready, running, handoff, finished }

class BombRound {
  BombRound({required this.players, required this.totalDuration})
    : assert(players.length >= 2),
      assert(totalDuration > Duration.zero),
      remaining = totalDuration;

  final List<String> players;
  final Duration totalDuration;

  Duration remaining;
  int currentPlayerIndex = 0;
  BombPhase phase = BombPhase.ready;

  String get currentPlayer => players[currentPlayerIndex];

  void start() {
    if (phase == BombPhase.ready) phase = BombPhase.running;
  }

  void elapse(Duration elapsed) {
    if (phase != BombPhase.running || elapsed <= Duration.zero) return;

    // 只在当前玩家持有炸弹时消耗时间。
    if (elapsed >= remaining) {
      remaining = Duration.zero;
      phase = BombPhase.finished;
      return;
    }

    remaining -= elapsed;
  }

  void pauseAndPass() {
    if (phase != BombPhase.running) return;

    // 暂停成功后立即记录下一位玩家，交接期间不计时。
    currentPlayerIndex = (currentPlayerIndex + 1) % players.length;
    phase = BombPhase.handoff;
  }

  void resume() {
    if (phase == BombPhase.handoff) phase = BombPhase.running;
  }

  void restart() {
    remaining = totalDuration;
    currentPlayerIndex = 0;
    phase = BombPhase.ready;
  }
}
