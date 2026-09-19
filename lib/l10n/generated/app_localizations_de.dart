// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Sprache';

  @override
  String get systemLanguage => 'Systemsprache verwenden';

  @override
  String playerDefault(int index) {
    return 'Spieler $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Nur $count Kanäle verfügbar. Verbinde weitere Geräte.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '$succeeded / $total Kanäle getestet. Bitte prüfen und bestätigen.';
  }

  @override
  String get channelTestSuccess =>
      'Test abgeschlossen. Spieler und Kanal bestätigen.';

  @override
  String get channelTestFailure =>
      'Kanaltest fehlgeschlagen. Geräteverbindung prüfen.';

  @override
  String get completeSafetyTestFirst =>
      'Zuerst den Sicherheitstest für diesen Spieler abschließen.';

  @override
  String get playerNameRequired => 'Für jeden Spieler einen Namen eingeben.';

  @override
  String get durationInvalid =>
      'Die Spieldauer muss mehr als 0 Sekunden betragen.';

  @override
  String get assignmentRequired =>
      'Jeder Spieler benötigt einen A/B-Kanal eines verbundenen Geräts.';

  @override
  String get assignmentTestRequired =>
      'Jeder Spielerkanal muss den Sicherheitstest bestehen.';

  @override
  String get assignmentConfirmRequired =>
      'Alle Spieler-Kanal-Zuordnungen bestätigen.';

  @override
  String get connectDevice => 'Geräte verbinden';

  @override
  String get notConnected => 'Nicht verbunden';

  @override
  String devicesOnline(int count) {
    return '$count online';
  }

  @override
  String get gameSettings => 'Spieleinstellungen';

  @override
  String get duration => 'Spieldauer';

  @override
  String get seconds => 'Sek.';

  @override
  String get bindPlayers => 'Spieler zuordnen';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total bestätigt';
  }

  @override
  String get testingChannels => 'Kanäle werden getestet';

  @override
  String get autoAssignAndTest => 'Automatisch zuordnen und testen';

  @override
  String get addPlayer => 'Spieler hinzufügen';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Zugeordnet $assigned / $total · Getestet $tested / $total · Bestätigt $confirmed / $total';
  }

  @override
  String get startIgnition => 'Zündung starten';

  @override
  String get deviceNeeded => 'Vor der Kanalzuordnung ein Gerät verbinden.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B verfügbar';
  }

  @override
  String get searchAndConnect => 'Geräte suchen und verbinden';

  @override
  String get manageDevices => 'Geräte verwalten';

  @override
  String playerHint(int index) {
    return 'Spieler $index';
  }

  @override
  String get removePlayer => 'Spieler entfernen';

  @override
  String get deviceChannel => 'Gerätekanal';

  @override
  String get unassigned => 'Nicht zugeordnet';

  @override
  String get testing => 'Test läuft';

  @override
  String get retest => 'Erneut testen';

  @override
  String get safetyTest => 'Sicherheitstest';

  @override
  String get confirmed => 'Bestätigt';

  @override
  String get confirmAssignment => 'Bestätigen';

  @override
  String get punishmentDevices => 'Strafgeräte';

  @override
  String get stopAll => 'Alle stoppen';

  @override
  String get searching => 'Suche läuft';

  @override
  String get searchAgain => 'Erneut suchen';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices verbunden · $channels Kanäle verfügbar';
  }

  @override
  String get turnOnDevices =>
      'Gerät einschalten und nahe ans Smartphone legen.';

  @override
  String get connecting => 'Verbindung läuft';

  @override
  String get disconnect => 'Trennen';

  @override
  String get connect => 'Verbinden';

  @override
  String get firstGeneration => '1. Generation';

  @override
  String get secondGeneration => '2. Generation';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Kanal $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Verbindung fehlgeschlagen: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Wellentest fehlgeschlagen: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Auslösung fehlgeschlagen: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Stoppen fehlgeschlagen: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Not-Aus fehlgeschlagen: $detail';
  }

  @override
  String get triggeringDevice => 'Strafgerät wird ausgelöst…';

  @override
  String get minimumGrams => 'Pro Runde mindestens 1 Gramm hinzufügen.';

  @override
  String remainingGramsLimit(int grams) {
    return 'Du kannst noch bis zu $grams Gramm hinzufügen.';
  }

  @override
  String loadBomb(int grams) {
    return '$grams-g-Bombe wird geladen';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Betäubend hinzufügen ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Scharf hinzufügen ×$count';
  }

  @override
  String get keepOriginal => 'Originalgeschmack bleibt';

  @override
  String get sealed => 'Bombe versiegelt';

  @override
  String get playerHasNoDevice => 'Diesem Spieler ist kein Gerät zugeordnet.';

  @override
  String devicesTriggered(int count) {
    return '$count Gerät(e) ausgelöst';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted Geräte ausgelöst';
  }

  @override
  String get exitGame => 'Spiel verlassen';

  @override
  String playerPosition(int current, int total) {
    return 'Spieler $current / $total';
  }

  @override
  String get currentPlayer => 'Aktueller Spieler';

  @override
  String get pauseAndPass => 'Pausieren und weitergeben';

  @override
  String get readyToTakeOver => 'Bereit machen';

  @override
  String get readyToIgnite => 'Bereit zum Zünden';

  @override
  String get handPhoneTo => 'Smartphone weitergeben an';

  @override
  String get remainingTime => 'Verbleibende Zeit';

  @override
  String remainingTimeSemantics(String time) {
    return 'Verbleibende Zeit $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bombe gesamt: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'Diese Bombe braucht mehr Wumms';

  @override
  String get seasoningPromptBody =>
      'Jedes Gramm und jede Würze bleibt für den Nächsten.';

  @override
  String get addGramsThisTurn => 'Gramm in dieser Runde';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Betäubend';

  @override
  String get addSpicy => 'Scharf';

  @override
  String get takeBomb => 'Bombe übernehmen';

  @override
  String get addingSeasoning => 'Würze wird hinzugefügt';

  @override
  String get boom => 'BUMM!';

  @override
  String get takePunishment => 'Strafe erhalten';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Noch einmal';

  @override
  String get resetGame => 'Einstellungen ändern';

  @override
  String get exitRoundTitle => 'Dieses Spiel verlassen?';

  @override
  String get exitRoundBody => 'Der aktuelle Countdown geht verloren.';

  @override
  String get continueGame => 'Weiterspielen';

  @override
  String get exit => 'Verlassen';

  @override
  String get originalFlavor => 'Original';

  @override
  String get numbFlavor => 'Betäubend';

  @override
  String numbFlavorCount(int count) {
    return 'Betäubend ×$count';
  }

  @override
  String get spicyFlavor => 'Scharf';

  @override
  String spicyFlavorCount(int count) {
    return 'Scharf ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Betäubend ×$numb · Scharf ×$spicy';
  }
}
