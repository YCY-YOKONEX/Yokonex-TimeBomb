// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Yokonex Таймер-бомба';

  @override
  String get language => 'Язык';

  @override
  String get systemLanguage => 'Использовать язык системы';

  @override
  String playerDefault(int index) {
    return 'Игрок $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Доступно только $count каналов. Подключите больше устройств.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return 'Проверено $succeeded / $total каналов. Проверьте и подтвердите каждый.';
  }

  @override
  String get channelTestSuccess =>
      'Тест завершён. Подтвердите соответствие игрока и канала.';

  @override
  String get channelTestFailure =>
      'Тест канала не пройден. Проверьте подключение устройства.';

  @override
  String get completeSafetyTestFirst =>
      'Сначала завершите проверку безопасности этого игрока.';

  @override
  String get playerNameRequired => 'Введите имя каждого игрока.';

  @override
  String get durationInvalid =>
      'Длительность игры должна быть больше 0 секунд.';

  @override
  String get assignmentRequired =>
      'Каждому игроку нужен канал A/B подключённого устройства.';

  @override
  String get assignmentTestRequired =>
      'Каждый канал игрока должен пройти проверку безопасности.';

  @override
  String get assignmentConfirmRequired =>
      'Подтвердите все назначения игроков и каналов.';

  @override
  String get connectDevice => 'Подключить устройства';

  @override
  String get notConnected => 'Не подключено';

  @override
  String devicesOnline(int count) {
    return 'В сети: $count';
  }

  @override
  String get gameSettings => 'Настройки игры';

  @override
  String get duration => 'Длительность игры';

  @override
  String get seconds => 'с';

  @override
  String get bindPlayers => 'Назначить игроков';

  @override
  String confirmedCount(int confirmed, int total) {
    return 'Подтверждено $confirmed / $total';
  }

  @override
  String get testingChannels => 'Проверка каналов';

  @override
  String get autoAssignAndTest => 'Назначить и проверить';

  @override
  String get addPlayer => 'Добавить игрока';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Назначено $assigned / $total · Проверено $tested / $total · Подтверждено $confirmed / $total';
  }

  @override
  String get startIgnition => 'Начать поджиг';

  @override
  String get deviceNeeded => 'Подключите устройство перед назначением каналов.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B доступны';
  }

  @override
  String get searchAndConnect => 'Найти и подключить устройства';

  @override
  String get manageDevices => 'Управление устройствами';

  @override
  String playerHint(int index) {
    return 'Игрок $index';
  }

  @override
  String get removePlayer => 'Удалить игрока';

  @override
  String get deviceChannel => 'Канал устройства';

  @override
  String get unassigned => 'Не назначено';

  @override
  String get testing => 'Проверка';

  @override
  String get retest => 'Проверить снова';

  @override
  String get safetyTest => 'Проверка безопасности';

  @override
  String get confirmed => 'Подтверждено';

  @override
  String get confirmAssignment => 'Подтвердить';

  @override
  String get punishmentDevices => 'Устройства наказания';

  @override
  String get stopAll => 'Остановить всё';

  @override
  String get searching => 'Поиск';

  @override
  String get searchAgain => 'Искать снова';

  @override
  String connectionSummary(int devices, int channels) {
    return 'Подключено $devices · Доступно каналов: $channels';
  }

  @override
  String get turnOnDevices =>
      'Включите устройство и держите его рядом с телефоном.';

  @override
  String get connecting => 'Подключение';

  @override
  String get disconnect => 'Отключить';

  @override
  String get connect => 'Подключить';

  @override
  String get firstGeneration => '1-е поколение';

  @override
  String get secondGeneration => '2-е поколение';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Канал $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Ошибка подключения: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Ошибка проверки сигнала: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Ошибка срабатывания: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Ошибка остановки: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Ошибка аварийной остановки: $detail';
  }

  @override
  String get triggeringDevice => 'Запуск устройства наказания…';

  @override
  String get minimumGrams => 'Добавляйте не менее 1 грамма за ход.';

  @override
  String remainingGramsLimit(int grams) {
    return 'В этой игре можно добавить ещё до $grams г.';
  }

  @override
  String loadBomb(int grams) {
    return 'Загрузка бомбы: $grams г';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Добавление онемения ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Добавление остроты ×$count';
  }

  @override
  String get keepOriginal => 'Оригинальный вкус';

  @override
  String get sealed => 'Бомба запечатана';

  @override
  String get playerHasNoDevice => 'Этому игроку не назначено устройство.';

  @override
  String devicesTriggered(int count) {
    return 'Сработало устройств: $count';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return 'Сработало $succeeded / $attempted устройств';
  }

  @override
  String get exitGame => 'Выйти из игры';

  @override
  String playerPosition(int current, int total) {
    return 'Игрок $current / $total';
  }

  @override
  String get currentPlayer => 'Текущий игрок';

  @override
  String get pauseAndPass => 'Пауза и передача';

  @override
  String get readyToTakeOver => 'Приготовьтесь';

  @override
  String get readyToIgnite => 'Готово к поджигу';

  @override
  String get handPhoneTo => 'Передайте телефон игроку';

  @override
  String get remainingTime => 'Осталось времени';

  @override
  String remainingTimeSemantics(String time) {
    return 'Осталось времени: $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Бомба: $grams г · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'Этой бомбе не хватает остроты';

  @override
  String get seasoningPromptBody =>
      'Каждый грамм и вкус останется следующему игроку.';

  @override
  String get addGramsThisTurn => 'Граммы на этом ходу';

  @override
  String get grams => 'г';

  @override
  String get addNumb => 'Добавить онемение';

  @override
  String get addSpicy => 'Добавить остроту';

  @override
  String get takeBomb => 'Принять бомбу';

  @override
  String get addingSeasoning => 'Добавление приправ';

  @override
  String get boom => 'БУМ!';

  @override
  String get takePunishment => 'Получите наказание';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams г · $flavor';
  }

  @override
  String get playAgain => 'Играть снова';

  @override
  String get resetGame => 'Изменить настройки';

  @override
  String get exitRoundTitle => 'Выйти из этой игры?';

  @override
  String get exitRoundBody => 'Текущий обратный отсчёт будет потерян.';

  @override
  String get continueGame => 'Продолжить';

  @override
  String get exit => 'Выйти';

  @override
  String get originalFlavor => 'Оригинальный';

  @override
  String get numbFlavor => 'Онемение';

  @override
  String numbFlavorCount(int count) {
    return 'Онемение ×$count';
  }

  @override
  String get spicyFlavor => 'Острый';

  @override
  String spicyFlavorCount(int count) {
    return 'Острый ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Онемение ×$numb · Острый ×$spicy';
  }
}
