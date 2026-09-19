// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Langue';

  @override
  String get systemLanguage => 'Langue du système';

  @override
  String playerDefault(int index) {
    return 'Joueur $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Seulement $count canaux sont disponibles. Connectez plus d\'appareils.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '$succeeded / $total canaux testés. Vérifiez et confirmez chacun.';
  }

  @override
  String get channelTestSuccess =>
      'Test terminé. Confirmez que le joueur et le canal correspondent.';

  @override
  String get channelTestFailure =>
      'Échec du test du canal. Vérifiez la connexion de l\'appareil.';

  @override
  String get completeSafetyTestFirst =>
      'Effectuez d\'abord le test de sécurité de ce joueur.';

  @override
  String get playerNameRequired => 'Saisissez le nom de chaque joueur.';

  @override
  String get durationInvalid => 'La durée doit être supérieure à 0 seconde.';

  @override
  String get assignmentRequired =>
      'Chaque joueur doit avoir un canal A/B sur un appareil connecté.';

  @override
  String get assignmentTestRequired =>
      'Chaque canal de joueur doit réussir le test de sécurité.';

  @override
  String get assignmentConfirmRequired =>
      'Confirmez chaque association joueur-canal.';

  @override
  String get connectDevice => 'Connecter les appareils';

  @override
  String get notConnected => 'Non connecté';

  @override
  String devicesOnline(int count) {
    return '$count en ligne';
  }

  @override
  String get gameSettings => 'Paramètres de jeu';

  @override
  String get duration => 'Durée de la partie';

  @override
  String get seconds => 's';

  @override
  String get bindPlayers => 'Attribuer les joueurs';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total confirmés';
  }

  @override
  String get testingChannels => 'Test des canaux';

  @override
  String get autoAssignAndTest => 'Attribuer et tester';

  @override
  String get addPlayer => 'Ajouter un joueur';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Attribués $assigned / $total · Testés $tested / $total · Confirmés $confirmed / $total';
  }

  @override
  String get startIgnition => 'Allumer la mèche';

  @override
  String get deviceNeeded =>
      'Connectez un appareil avant d\'attribuer les canaux.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B disponibles';
  }

  @override
  String get searchAndConnect => 'Rechercher et connecter';

  @override
  String get manageDevices => 'Gérer les appareils';

  @override
  String playerHint(int index) {
    return 'Joueur $index';
  }

  @override
  String get removePlayer => 'Supprimer le joueur';

  @override
  String get deviceChannel => 'Canal de l\'appareil';

  @override
  String get unassigned => 'Non attribué';

  @override
  String get testing => 'Test en cours';

  @override
  String get retest => 'Retester';

  @override
  String get safetyTest => 'Test de sécurité';

  @override
  String get confirmed => 'Confirmé';

  @override
  String get confirmAssignment => 'Confirmer';

  @override
  String get punishmentDevices => 'Appareils de sanction';

  @override
  String get stopAll => 'Tout arrêter';

  @override
  String get searching => 'Recherche';

  @override
  String get searchAgain => 'Rechercher';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices connectés · $channels canaux disponibles';
  }

  @override
  String get turnOnDevices =>
      'Allumez un appareil et gardez-le près du téléphone.';

  @override
  String get connecting => 'Connexion';

  @override
  String get disconnect => 'Déconnecter';

  @override
  String get connect => 'Connecter';

  @override
  String get firstGeneration => '1re génération';

  @override
  String get secondGeneration => '2e génération';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Canal $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Échec de la connexion : $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Échec du test d\'onde : $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Échec du déclenchement : $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Échec de l\'arrêt : $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Échec de l\'arrêt d\'urgence : $detail';
  }

  @override
  String get triggeringDevice => 'Déclenchement de l\'appareil…';

  @override
  String get minimumGrams => 'Ajoutez au moins 1 gramme par tour.';

  @override
  String remainingGramsLimit(int grams) {
    return 'Vous pouvez encore ajouter $grams grammes.';
  }

  @override
  String loadBomb(int grams) {
    return 'Chargement de la bombe de $grams g';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Ajout engourdissant ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Ajout épicé ×$count';
  }

  @override
  String get keepOriginal => 'Saveur originale';

  @override
  String get sealed => 'Bombe scellée';

  @override
  String get playerHasNoDevice => 'Aucun appareil n\'est attribué à ce joueur.';

  @override
  String devicesTriggered(int count) {
    return '$count appareil(s) déclenché(s)';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted appareils déclenchés';
  }

  @override
  String get exitGame => 'Quitter la partie';

  @override
  String playerPosition(int current, int total) {
    return 'Joueur $current / $total';
  }

  @override
  String get currentPlayer => 'Joueur actuel';

  @override
  String get pauseAndPass => 'Pause et passer';

  @override
  String get readyToTakeOver => 'Préparez-vous';

  @override
  String get readyToIgnite => 'Prêt à allumer';

  @override
  String get handPhoneTo => 'Donnez le téléphone à';

  @override
  String get remainingTime => 'Temps restant';

  @override
  String remainingTimeSemantics(String time) {
    return 'Temps restant $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bombe : $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'Cette bombe manque de piquant';

  @override
  String get seasoningPromptBody =>
      'Chaque gramme et chaque saveur restent pour le suivant.';

  @override
  String get addGramsThisTurn => 'Grammes à ajouter';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Ajouter engourdissant';

  @override
  String get addSpicy => 'Ajouter épicé';

  @override
  String get takeBomb => 'Prendre la bombe';

  @override
  String get addingSeasoning => 'Ajout des saveurs';

  @override
  String get boom => 'BOUM !';

  @override
  String get takePunishment => 'Recevez la sanction';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Rejouer';

  @override
  String get resetGame => 'Modifier les réglages';

  @override
  String get exitRoundTitle => 'Quitter cette partie ?';

  @override
  String get exitRoundBody => 'Le compte à rebours actuel sera perdu.';

  @override
  String get continueGame => 'Continuer';

  @override
  String get exit => 'Quitter';

  @override
  String get originalFlavor => 'Original';

  @override
  String get numbFlavor => 'Engourdissant';

  @override
  String numbFlavorCount(int count) {
    return 'Engourdissant ×$count';
  }

  @override
  String get spicyFlavor => 'Épicé';

  @override
  String spicyFlavorCount(int count) {
    return 'Épicé ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Engourdissant ×$numb · Épicé ×$spicy';
  }
}
