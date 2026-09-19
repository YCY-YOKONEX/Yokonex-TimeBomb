import 'package:flutter_test/flutter_test.dart';
import 'package:yokonex_time_bomb/game/bomb_round.dart';

void main() {
  group('BombRound', () {
    test('开始后消耗倒计时', () {
      final round = BombRound(
        players: const ['甲', '乙'],
        totalDuration: const Duration(seconds: 30),
      );

      round.start();
      round.elapse(const Duration(seconds: 8));

      expect(round.phase, BombPhase.running);
      expect(round.remaining, const Duration(seconds: 22));
      expect(round.currentPlayer, '甲');
    });

    test('暂停后切换到下一位玩家，交接时不计时', () {
      final round = BombRound(
        players: const ['甲', '乙', '丙'],
        totalDuration: const Duration(seconds: 30),
      )..start();

      round.pauseAndPass();
      round.elapse(const Duration(seconds: 5));

      expect(round.phase, BombPhase.handoff);
      expect(round.currentPlayer, '乙');
      expect(round.remaining, const Duration(seconds: 30));

      round.resume();
      expect(round.phase, BombPhase.running);
    });

    test('倒计时归零时当前玩家失败', () {
      final round = BombRound(
        players: const ['甲', '乙'],
        totalDuration: const Duration(seconds: 10),
      )..start();

      round.pauseAndPass();
      round.resume();
      round.elapse(const Duration(seconds: 10));

      expect(round.phase, BombPhase.finished);
      expect(round.remaining, Duration.zero);
      expect(round.currentPlayer, '乙');
    });

    test('最后一位暂停后回到第一位', () {
      final round = BombRound(
        players: const ['甲', '乙'],
        totalDuration: const Duration(seconds: 10),
      )..start();

      round.pauseAndPass();
      round.resume();
      round.pauseAndPass();

      expect(round.currentPlayer, '甲');
    });
  });
}
