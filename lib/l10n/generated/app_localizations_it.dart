// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Lingua';

  @override
  String get systemLanguage => 'Usa la lingua di sistema';

  @override
  String playerDefault(int index) {
    return 'Giocatore $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Sono disponibili solo $count canali. Collega altri dispositivi.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return 'Testati $succeeded / $total canali. Controllali e confermali.';
  }

  @override
  String get channelTestSuccess =>
      'Test completato. Conferma che giocatore e canale corrispondano.';

  @override
  String get channelTestFailure =>
      'Test del canale non riuscito. Controlla la connessione.';

  @override
  String get completeSafetyTestFirst =>
      'Completa prima il test di sicurezza di questo giocatore.';

  @override
  String get playerNameRequired => 'Inserisci un nome per ogni giocatore.';

  @override
  String get durationInvalid => 'La durata deve essere superiore a 0 secondi.';

  @override
  String get assignmentRequired =>
      'Ogni giocatore deve avere un canale A/B di un dispositivo collegato.';

  @override
  String get assignmentTestRequired =>
      'Ogni canale deve superare il test di sicurezza.';

  @override
  String get assignmentConfirmRequired =>
      'Conferma ogni associazione tra giocatore e canale.';

  @override
  String get connectDevice => 'Collega dispositivi';

  @override
  String get notConnected => 'Non collegato';

  @override
  String devicesOnline(int count) {
    return '$count online';
  }

  @override
  String get gameSettings => 'Impostazioni di gioco';

  @override
  String get duration => 'Durata della partita';

  @override
  String get seconds => 'sec';

  @override
  String get bindPlayers => 'Assegna giocatori';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total confermati';
  }

  @override
  String get testingChannels => 'Test dei canali';

  @override
  String get autoAssignAndTest => 'Assegna e testa';

  @override
  String get addPlayer => 'Aggiungi giocatore';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Assegnati $assigned / $total · Testati $tested / $total · Confermati $confirmed / $total';
  }

  @override
  String get startIgnition => 'Avvia accensione';

  @override
  String get deviceNeeded =>
      'Collega un dispositivo prima di assegnare i canali.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B disponibili';
  }

  @override
  String get searchAndConnect => 'Cerca e collega dispositivi';

  @override
  String get manageDevices => 'Gestisci dispositivi';

  @override
  String playerHint(int index) {
    return 'Giocatore $index';
  }

  @override
  String get removePlayer => 'Rimuovi giocatore';

  @override
  String get deviceChannel => 'Canale dispositivo';

  @override
  String get unassigned => 'Non assegnato';

  @override
  String get testing => 'Test in corso';

  @override
  String get retest => 'Ripeti test';

  @override
  String get safetyTest => 'Test di sicurezza';

  @override
  String get confirmed => 'Confermato';

  @override
  String get confirmAssignment => 'Conferma';

  @override
  String get punishmentDevices => 'Dispositivi di punizione';

  @override
  String get stopAll => 'Ferma tutto';

  @override
  String get searching => 'Ricerca';

  @override
  String get searchAgain => 'Cerca di nuovo';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices collegati · $channels canali disponibili';
  }

  @override
  String get turnOnDevices =>
      'Accendi un dispositivo e tienilo vicino al telefono.';

  @override
  String get connecting => 'Connessione';

  @override
  String get disconnect => 'Disconnetti';

  @override
  String get connect => 'Connetti';

  @override
  String get firstGeneration => '1ª generazione';

  @override
  String get secondGeneration => '2ª generazione';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Canale $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Connessione non riuscita: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Test dell\'onda non riuscito: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Attivazione non riuscita: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Arresto non riuscito: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Arresto di emergenza non riuscito: $detail';
  }

  @override
  String get triggeringDevice => 'Attivazione del dispositivo di punizione…';

  @override
  String get minimumGrams => 'Aggiungi almeno 1 grammo per turno.';

  @override
  String remainingGramsLimit(int grams) {
    return 'Puoi aggiungere ancora fino a $grams grammi.';
  }

  @override
  String loadBomb(int grams) {
    return 'Caricamento bomba da $grams g';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Aggiunta effetto intorpidente ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Aggiunta piccante ×$count';
  }

  @override
  String get keepOriginal => 'Gusto originale';

  @override
  String get sealed => 'Bomba sigillata';

  @override
  String get playerHasNoDevice =>
      'Nessun dispositivo assegnato a questo giocatore.';

  @override
  String devicesTriggered(int count) {
    return '$count dispositivo/i attivato/i';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted dispositivi attivati';
  }

  @override
  String get exitGame => 'Esci dal gioco';

  @override
  String playerPosition(int current, int total) {
    return 'Giocatore $current / $total';
  }

  @override
  String get currentPlayer => 'Giocatore attuale';

  @override
  String get pauseAndPass => 'Pausa e passa';

  @override
  String get readyToTakeOver => 'Preparati';

  @override
  String get readyToIgnite => 'Pronto ad accendere';

  @override
  String get handPhoneTo => 'Passa il telefono a';

  @override
  String get remainingTime => 'Tempo rimasto';

  @override
  String remainingTimeSemantics(String time) {
    return 'Tempo rimasto $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bomba totale: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'Questa bomba ha bisogno di più carattere';

  @override
  String get seasoningPromptBody =>
      'Ogni grammo e sapore resta per il giocatore successivo.';

  @override
  String get addGramsThisTurn => 'Grammi da aggiungere';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Effetto intorpidente';

  @override
  String get addSpicy => 'Piccante';

  @override
  String get takeBomb => 'Prendi la bomba';

  @override
  String get addingSeasoning => 'Aggiunta condimenti';

  @override
  String get boom => 'BOOM!';

  @override
  String get takePunishment => 'Ricevi la punizione';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Gioca ancora';

  @override
  String get resetGame => 'Modifica impostazioni';

  @override
  String get exitRoundTitle => 'Uscire da questa partita?';

  @override
  String get exitRoundBody => 'Il conto alla rovescia attuale andrà perso.';

  @override
  String get continueGame => 'Continua';

  @override
  String get exit => 'Esci';

  @override
  String get originalFlavor => 'Originale';

  @override
  String get numbFlavor => 'Intorpidente';

  @override
  String numbFlavorCount(int count) {
    return 'Intorpidente ×$count';
  }

  @override
  String get spicyFlavor => 'Piccante';

  @override
  String spicyFlavorCount(int count) {
    return 'Piccante ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Intorpidente ×$numb · Piccante ×$spicy';
  }
}
