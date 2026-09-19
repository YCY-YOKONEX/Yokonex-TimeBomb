// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Yokonex Time Bomb';

  @override
  String get language => 'Language';

  @override
  String get systemLanguage => 'Use system language';

  @override
  String playerDefault(int index) {
    return 'Player $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return 'Only $count channels are available. Connect more devices.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return 'Tested $succeeded / $total channels. Check and confirm each one.';
  }

  @override
  String get channelTestSuccess =>
      'Test complete. Confirm the player and channel match.';

  @override
  String get channelTestFailure =>
      'Channel test failed. Check the device connection.';

  @override
  String get completeSafetyTestFirst =>
      'Complete this player\'s safety test first.';

  @override
  String get playerNameRequired => 'Enter a name for every player.';

  @override
  String get durationInvalid => 'Game duration must be greater than 0 seconds.';

  @override
  String get assignmentRequired =>
      'Every player needs an A/B channel on a connected device.';

  @override
  String get assignmentTestRequired =>
      'Every player channel must pass the safety test.';

  @override
  String get assignmentConfirmRequired =>
      'Confirm every player and channel pairing.';

  @override
  String get connectDevice => 'Connect Devices';

  @override
  String get notConnected => 'Not connected';

  @override
  String devicesOnline(int count) {
    return '$count online';
  }

  @override
  String get gameSettings => 'Game Settings';

  @override
  String get duration => 'Game duration';

  @override
  String get seconds => 'sec';

  @override
  String get bindPlayers => 'Assign Players';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total confirmed';
  }

  @override
  String get testingChannels => 'Testing channels';

  @override
  String get autoAssignAndTest => 'Auto-assign and test';

  @override
  String get addPlayer => 'Add player';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return 'Assigned $assigned / $total · Tested $tested / $total · Confirmed $confirmed / $total';
  }

  @override
  String get startIgnition => 'Start Ignition';

  @override
  String get deviceNeeded =>
      'Connect a device before assigning player channels.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B available';
  }

  @override
  String get searchAndConnect => 'Find and connect devices';

  @override
  String get manageDevices => 'Manage devices';

  @override
  String playerHint(int index) {
    return 'Player $index';
  }

  @override
  String get removePlayer => 'Remove player';

  @override
  String get deviceChannel => 'Device channel';

  @override
  String get unassigned => 'Unassigned';

  @override
  String get testing => 'Testing';

  @override
  String get retest => 'Test again';

  @override
  String get safetyTest => 'Safety test';

  @override
  String get confirmed => 'Confirmed';

  @override
  String get confirmAssignment => 'Confirm';

  @override
  String get punishmentDevices => 'Punishment Devices';

  @override
  String get stopAll => 'Stop all';

  @override
  String get searching => 'Searching';

  @override
  String get searchAgain => 'Search again';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices connected · $channels channels available';
  }

  @override
  String get turnOnDevices => 'Turn on a device and keep it near your phone.';

  @override
  String get connecting => 'Connecting';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get connect => 'Connect';

  @override
  String get firstGeneration => '1st generation';

  @override
  String get secondGeneration => '2nd generation';

  @override
  String channelLabel(String name, String channel) {
    return '$name · Channel $channel';
  }

  @override
  String connectionFailed(String detail) {
    return 'Connection failed: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return 'Waveform test failed: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return 'Trigger failed: $detail';
  }

  @override
  String stopFailed(String detail) {
    return 'Stop failed: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return 'Emergency stop failed: $detail';
  }

  @override
  String get triggeringDevice => 'Triggering punishment device…';

  @override
  String get minimumGrams => 'Add at least 1 gram each turn.';

  @override
  String remainingGramsLimit(int grams) {
    return 'You can add up to $grams more grams this game.';
  }

  @override
  String loadBomb(int grams) {
    return 'Loading $grams g bomb';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'Adding numb ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return 'Adding spice ×$count';
  }

  @override
  String get keepOriginal => 'Keeping original flavor';

  @override
  String get sealed => 'Bomb sealed';

  @override
  String get playerHasNoDevice => 'No device is assigned to this player.';

  @override
  String devicesTriggered(int count) {
    return 'Triggered $count device(s)';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return 'Triggered $succeeded / $attempted devices';
  }

  @override
  String get exitGame => 'Exit game';

  @override
  String playerPosition(int current, int total) {
    return 'Player $current / $total';
  }

  @override
  String get currentPlayer => 'Current player';

  @override
  String get pauseAndPass => 'Pause and pass';

  @override
  String get readyToTakeOver => 'Get Ready';

  @override
  String get readyToIgnite => 'Ready to Ignite';

  @override
  String get handPhoneTo => 'Hand the phone to';

  @override
  String get remainingTime => 'Time Remaining';

  @override
  String remainingTimeSemantics(String time) {
    return 'Time remaining $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return 'Bomb total: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'This bomb needs more kick';

  @override
  String get seasoningPromptBody =>
      'Every gram and flavor stays for the next player.';

  @override
  String get addGramsThisTurn => 'Grams to add this turn';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'Add Numb';

  @override
  String get addSpicy => 'Add Spice';

  @override
  String get takeBomb => 'Take the Bomb';

  @override
  String get addingSeasoning => 'Adding Seasoning';

  @override
  String get boom => 'BOOM!';

  @override
  String get takePunishment => 'Take the punishment';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'Play Again';

  @override
  String get resetGame => 'Change Setup';

  @override
  String get exitRoundTitle => 'Exit this game?';

  @override
  String get exitRoundBody => 'The current countdown will be lost.';

  @override
  String get continueGame => 'Keep Playing';

  @override
  String get exit => 'Exit';

  @override
  String get originalFlavor => 'Original';

  @override
  String get numbFlavor => 'Numb';

  @override
  String numbFlavorCount(int count) {
    return 'Numb ×$count';
  }

  @override
  String get spicyFlavor => 'Spicy';

  @override
  String spicyFlavorCount(int count) {
    return 'Spicy ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'Numb ×$numb · Spicy ×$spicy';
  }
}
