// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Yokonex タイムボム';

  @override
  String get language => '言語';

  @override
  String get systemLanguage => 'システム言語を使用';

  @override
  String playerDefault(int index) {
    return 'プレイヤー $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return '使用可能なチャンネルは $count 個です。デバイスを追加してください。';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '$succeeded / $total チャンネルをテストしました。確認してください。';
  }

  @override
  String get channelTestSuccess => 'テスト完了。プレイヤーとチャンネルの対応を確認してください。';

  @override
  String get channelTestFailure => 'チャンネルテストに失敗しました。接続を確認してください。';

  @override
  String get completeSafetyTestFirst => '先にこのプレイヤーの安全テストを完了してください。';

  @override
  String get playerNameRequired => 'すべてのプレイヤー名を入力してください。';

  @override
  String get durationInvalid => 'ゲーム時間は 0 秒より長くしてください。';

  @override
  String get assignmentRequired => '各プレイヤーに接続済みデバイスの A/B チャンネルを割り当ててください。';

  @override
  String get assignmentTestRequired => 'すべてのチャンネルで安全テストを完了してください。';

  @override
  String get assignmentConfirmRequired => 'プレイヤーとチャンネルの対応をすべて確認してください。';

  @override
  String get connectDevice => 'デバイスを接続';

  @override
  String get notConnected => '未接続';

  @override
  String devicesOnline(int count) {
    return '$count 台オンライン';
  }

  @override
  String get gameSettings => 'ゲーム設定';

  @override
  String get duration => 'ゲーム時間';

  @override
  String get seconds => '秒';

  @override
  String get bindPlayers => 'プレイヤーを割り当て';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total 確認済み';
  }

  @override
  String get testingChannels => 'チャンネルをテスト中';

  @override
  String get autoAssignAndTest => '自動割り当てとテスト';

  @override
  String get addPlayer => 'プレイヤーを追加';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return '割当 $assigned / $total · テスト $tested / $total · 確認 $confirmed / $total';
  }

  @override
  String get startIgnition => '点火開始';

  @override
  String get deviceNeeded => 'チャンネルを割り当てる前にデバイスを接続してください。';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B 使用可能';
  }

  @override
  String get searchAndConnect => 'デバイスを検索して接続';

  @override
  String get manageDevices => 'デバイスを管理';

  @override
  String playerHint(int index) {
    return 'プレイヤー $index';
  }

  @override
  String get removePlayer => 'プレイヤーを削除';

  @override
  String get deviceChannel => 'デバイスチャンネル';

  @override
  String get unassigned => '未割り当て';

  @override
  String get testing => 'テスト中';

  @override
  String get retest => '再テスト';

  @override
  String get safetyTest => '安全テスト';

  @override
  String get confirmed => '確認済み';

  @override
  String get confirmAssignment => '確認';

  @override
  String get punishmentDevices => '罰ゲームデバイス';

  @override
  String get stopAll => 'すべて停止';

  @override
  String get searching => '検索中';

  @override
  String get searchAgain => '再検索';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices 台接続 · $channels チャンネル使用可能';
  }

  @override
  String get turnOnDevices => 'デバイスの電源を入れ、スマートフォンに近づけてください。';

  @override
  String get connecting => '接続中';

  @override
  String get disconnect => '切断';

  @override
  String get connect => '接続';

  @override
  String get firstGeneration => '第1世代';

  @override
  String get secondGeneration => '第2世代';

  @override
  String channelLabel(String name, String channel) {
    return '$name · $channel チャンネル';
  }

  @override
  String connectionFailed(String detail) {
    return '接続に失敗しました: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return '波形テストに失敗しました: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return '作動に失敗しました: $detail';
  }

  @override
  String stopFailed(String detail) {
    return '停止に失敗しました: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return '緊急停止に失敗しました: $detail';
  }

  @override
  String get triggeringDevice => '罰ゲームデバイスを作動中…';

  @override
  String get minimumGrams => '毎ターン最低 1 グラム追加してください。';

  @override
  String remainingGramsLimit(int grams) {
    return 'このゲームではあと $grams グラム追加できます。';
  }

  @override
  String loadBomb(int grams) {
    return '$grams g の爆弾を装填';
  }

  @override
  String addNumbSeasoning(int count) {
    return 'しびれを追加 ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return '辛さを追加 ×$count';
  }

  @override
  String get keepOriginal => 'オリジナル味のまま';

  @override
  String get sealed => '爆弾を封印しました';

  @override
  String get playerHasNoDevice => 'このプレイヤーにはデバイスが割り当てられていません。';

  @override
  String devicesTriggered(int count) {
    return '$count 台のデバイスを作動';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '$succeeded / $attempted 台のデバイスを作動';
  }

  @override
  String get exitGame => 'ゲームを終了';

  @override
  String playerPosition(int current, int total) {
    return 'プレイヤー $current / $total';
  }

  @override
  String get currentPlayer => '現在のプレイヤー';

  @override
  String get pauseAndPass => '一時停止して渡す';

  @override
  String get readyToTakeOver => '準備してください';

  @override
  String get readyToIgnite => '点火準備';

  @override
  String get handPhoneTo => 'スマートフォンを渡す相手';

  @override
  String get remainingTime => '残り時間';

  @override
  String remainingTimeSemantics(String time) {
    return '残り時間 $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return '爆弾合計: $grams g · $flavor';
  }

  @override
  String get seasoningPromptTitle => 'この爆弾にはもっと刺激が必要';

  @override
  String get seasoningPromptBody => '追加した重さと味は、次のプレイヤーにも残ります。';

  @override
  String get addGramsThisTurn => '今回追加するグラム数';

  @override
  String get grams => 'g';

  @override
  String get addNumb => 'しびれを追加';

  @override
  String get addSpicy => '辛さを追加';

  @override
  String get takeBomb => '爆弾を受け取る';

  @override
  String get addingSeasoning => '調味料を追加中';

  @override
  String get boom => 'ドカン！';

  @override
  String get takePunishment => '罰ゲームを受ける';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams g · $flavor';
  }

  @override
  String get playAgain => 'もう一度';

  @override
  String get resetGame => '設定を変更';

  @override
  String get exitRoundTitle => 'ゲームを終了しますか？';

  @override
  String get exitRoundBody => '現在のカウントダウンは失われます。';

  @override
  String get continueGame => '続ける';

  @override
  String get exit => '終了';

  @override
  String get originalFlavor => 'オリジナル';

  @override
  String get numbFlavor => 'しびれ';

  @override
  String numbFlavorCount(int count) {
    return 'しびれ ×$count';
  }

  @override
  String get spicyFlavor => '辛さ';

  @override
  String spicyFlavorCount(int count) {
    return '辛さ ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return 'しびれ ×$numb · 辛さ ×$spicy';
  }
}
