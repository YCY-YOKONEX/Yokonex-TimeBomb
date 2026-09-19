// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Taal';

  @override
  String get systemLanguage => 'Systeemtaal gebruiken';

  @override
  String playerDefault(int index) {
    return 'Speler $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Er zijn slechts $count kanalen beschikbaar. Verbind meer apparaten.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '$succeeded / $total kanalen getest. Controleer en bevestig ze.';
  }

  @override
  String get channelTestSuccess =>
      'Test voltooid. Bevestig dat speler en kanaal kloppen.';

  @override
  String get channelTestFailure =>
      'Kanaaltest mislukt. Controleer de apparaatverbinding.';

  @override
  String get completeSafetyTestFirst =>
      'Voltooi eerst de veiligheidstest voor deze speler.';

  @override
  String get playerNameRequired => 'Voer voor elke speler een naam in.';

  @override
  String get durationInvalid => 'De spelduur moet langer zijn dan 0 seconden.';

  @override
  String get assignmentRequired =>
      'Elke speler heeft een A/B-kanaal van een verbonden apparaat nodig.';

  @override
  String get assignmentTestRequired =>
      'Elk spelerskanaal moet de veiligheidstest doorstaan.';

  @override
  String get assignmentConfirmRequired =>
      'Bevestig elke koppeling van speler en kanaal.';

  @override
  String get connectDevice => 'Apparaten verbinden';

  @override
  String get notConnected => 'Niet verbonden';

  @override
  String devicesOnline(int count) {
    return '$count online';
  }

  @override
  String get gameSettings => 'Spelinstellingen';

  @override
  String get duration => 'Spelduur';

  @override
  String get seconds => 'sec';

  @override
  String get bindPlayers => 'Spelers toewijzen';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total bevestigd';
  }

  @override
  String get testingChannels => 'Kanalen testen';

  @override
  String get autoAssignAndTest => 'Automatisch toewijzen en testen';

  @override
  String get addPlayer => 'Speler toevoegen';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Toegewezen $assigned / $total · Getest $tested / $total · Bevestigd $confirmed / $total';
  }

  @override
  String get startIgnition => 'Ontsteking starten';

  @override
  String get deviceNeeded =>
      'Verbind een apparaat voordat je kanalen toewijst.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B beschikbaar';
  }

  @override
  String get searchAndConnect => 'Apparaten zoeken en verbinden';

  @override
  String get manageDevices => 'Apparaten beheren';

  @override
  String playerHint(int index) {
    return 'Speler $index';
  }

  @override
  String get removePlayer => 'Speler verwijderen';

  @override
  String get deviceChannel => 'Apparaatkanaal';

  @override
  String get unassigned => 'Niet toegewezen';

  @override
  String get testing => 'Bezig met testen';

  @override
  String get retest => 'Opnieuw testen';

  @override
  String get safetyTest => 'Veiligheidstest';

  @override
  String get confirmed => 'Bevestigd';

  @override
  String get confirmAssignment => 'Bevestigen';

  @override
  String get punishmentDevices => 'Strafapparaten';

  @override
  String get stopAll => 'Alles stoppen';

  @override
  String get searching => 'Zoeken';

  @override
  String get searchAgain => 'Opnieuw zoeken';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices verbonden · $channels kanalen beschikbaar';
  }

  @override
  String get turnOnDevices =>
      'Zet een apparaat aan en houd het bij je telefoon.';

  @override
  String get connecting => 'Verbinden';

  @override
  String get disconnect => 'Verbreken';

  @override
  String get connect => 'Verbinden';

  @override
  String get firstGeneration => '1e generatie';

  @override
  String get secondGeneration => '2e generatie';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Kanaal $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Verbinding mislukt: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Golftest mislukt: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Activeren mislukt: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Stoppen mislukt: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Noodstop mislukt: $detail';
  }

  @override
  String get triggeringDevice => 'Strafapparaat wordt geactiveerd…';

  @override
  String get minimumGrams => 'Voeg per beurt minstens 1 gram toe.';

  @override
  String remainingGramsLimit(int grams) {
    return 'Je kunt nog maximaal $grams gram toevoegen.';
  }

  @override
  String loadBomb(int grams) {
    return 'Bom van $grams g laden';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Verdovend toevoegen ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Pittig toevoegen ×$count';
  }

  @override
  String get keepOriginal => 'Originele smaak behouden';

  @override
  String get sealed => 'Bom verzegeld';

  @override
  String get playerHasNoDevice =>
      'Aan deze speler is geen apparaat toegewezen.';

  @override
  String devicesTriggered(int count) {
    return '$count apparaat/apparaten geactiveerd';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted apparaten geactiveerd';
  }

  @override
  String get exitGame => 'Spel verlaten';

  @override
  String playerPosition(int current, int total) {
    return 'Speler $current / $total';
  }

  @override
  String get currentPlayer => 'Huidige speler';

  @override
  String get pauseAndPass => 'Pauzeren en doorgeven';

  @override
  String get readyToTakeOver => 'Maak je klaar';

  @override
  String get readyToIgnite => 'Klaar om te ontsteken';

  @override
  String get handPhoneTo => 'Geef de telefoon aan';

  @override
  String get remainingTime => 'Resterende tijd';

  @override
  String remainingTimeSemantics(String time) {
    return 'Resterende tijd $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bom totaal: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'Deze bom kan nog wat pit gebruiken';

  @override
  String get seasoningPromptBody =>
      'Elke gram en smaak blijft voor de volgende speler.';

  @override
  String get addGramsThisTurn => 'Gram toevoegen deze beurt';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Verdovend';

  @override
  String get addSpicy => 'Pittig';

  @override
  String get takeBomb => 'Bom overnemen';

  @override
  String get addingSeasoning => 'Smaak toevoegen';

  @override
  String get boom => 'BOEM!';

  @override
  String get takePunishment => 'Onderga de straf';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Opnieuw spelen';

  @override
  String get resetGame => 'Instellingen wijzigen';

  @override
  String get exitRoundTitle => 'Dit spel verlaten?';

  @override
  String get exitRoundBody => 'De huidige aftelling gaat verloren.';

  @override
  String get continueGame => 'Doorgaan';

  @override
  String get exit => 'Verlaten';

  @override
  String get originalFlavor => 'Origineel';

  @override
  String get numbFlavor => 'Verdovend';

  @override
  String numbFlavorCount(int count) {
    return 'Verdovend ×$count';
  }

  @override
  String get spicyFlavor => 'Pittig';

  @override
  String spicyFlavorCount(int count) {
    return 'Pittig ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Verdovend ×$numb · Pittig ×$spicy';
  }
}
