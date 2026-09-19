import 'package:flutter_test/flutter_test.dart';
import 'package:yokonex_time_bomb/game/player_bomb_settings.dart';

void main() {
  group('PlayerBombSettings', () {
    test('炸弹克数和麻辣按轮次累计', () {
      final settings = PlayerBombSettings();

      expect(settings.grams, 10);
      expect(settings.frequency, 50);
      expect(settings.addGrams(1), isTrue);
      expect(settings.grams, 11);
      expect(settings.addNumb(), isTrue);
      expect(settings.frequency, 55);

      expect(settings.addGrams(5), isTrue);
      expect(settings.grams, 16);
      expect(settings.addSpicy(), isTrue);
      expect(settings.frequency, 60);
      expect(settings.numbCount, 1);
      expect(settings.spicyCount, 1);

      for (var index = 0; index < 8; index++) {
        expect(settings.addNumb(), isTrue);
      }
      expect(settings.frequency, 100);
      expect(settings.canAddSeasoning, isFalse);
      expect(settings.addSpicy(), isFalse);
    });

    test('炸弹克数最少添加一克并限制上限', () {
      final settings = PlayerBombSettings(grams: PlayerBombSettings.maxGrams);

      expect(settings.addGrams(1), isFalse);
      expect(settings.grams, PlayerBombSettings.maxGrams);

      settings.grams = PlayerBombSettings.initialGrams;
      expect(settings.addGrams(0), isFalse);
      expect(settings.grams, PlayerBombSettings.initialGrams);
    });

    test('再来一局恢复默认配料', () {
      final settings = PlayerBombSettings();

      settings.addGrams(20);
      settings.addNumb();
      settings.addSpicy();
      settings.reset();

      expect(settings.grams, 10);
      expect(settings.numbCount, 0);
      expect(settings.spicyCount, 0);
      expect(settings.frequency, 50);
    });
  });
}
