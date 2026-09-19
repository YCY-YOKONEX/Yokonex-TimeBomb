// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '役次元-时间炸弹';

  @override
  String get language => '语言';

  @override
  String get systemLanguage => '跟随系统';

  @override
  String playerDefault(int index) {
    return '玩家 $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return '当前只有 $count 个可用通道，请连接更多设备';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '已完成 $succeeded / $total 个通道测试，请核对并确认';
  }

  @override
  String get channelTestSuccess => '测试完成，请确认玩家与通道是否对应';

  @override
  String get channelTestFailure => '通道测试失败，请检查设备连接';

  @override
  String get completeSafetyTestFirst => '请先完成该玩家的安全通道测试';

  @override
  String get playerNameRequired => '请填写每位玩家的名字';

  @override
  String get durationInvalid => '游戏时长必须是大于 0 的秒数';

  @override
  String get assignmentRequired => '每位玩家都必须绑定一个已连接设备的 A/B 通道';

  @override
  String get assignmentTestRequired => '每位玩家的通道都必须完成安全测试';

  @override
  String get assignmentConfirmRequired => '请逐项确认玩家与通道的对应关系';

  @override
  String get connectDevice => '连接电击器';

  @override
  String get notConnected => '尚未连接';

  @override
  String devicesOnline(int count) {
    return '$count 台在线';
  }

  @override
  String get gameSettings => '游戏参数';

  @override
  String get duration => '游戏时长';

  @override
  String get seconds => '秒';

  @override
  String get bindPlayers => '绑定玩家';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total 已确认';
  }

  @override
  String get testingChannels => '正在逐个测试';

  @override
  String get autoAssignAndTest => '自动分配并测试';

  @override
  String get addPlayer => '添加玩家';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return '已绑定 $assigned / $total · 已测试 $tested / $total · 已确认 $confirmed / $total';
  }

  @override
  String get startIgnition => '开始点火';

  @override
  String get deviceNeeded => '连接设备后才能分配玩家通道';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B 可用';
  }

  @override
  String get searchAndConnect => '搜索并连接设备';

  @override
  String get manageDevices => '管理连接设备';

  @override
  String playerHint(int index) {
    return '玩家 $index';
  }

  @override
  String get removePlayer => '删除玩家';

  @override
  String get deviceChannel => '设备通道';

  @override
  String get unassigned => '未绑定';

  @override
  String get testing => '测试中';

  @override
  String get retest => '重新测试';

  @override
  String get safetyTest => '安全测试';

  @override
  String get confirmed => '已确认';

  @override
  String get confirmAssignment => '确认绑定';

  @override
  String get punishmentDevices => '惩罚设备';

  @override
  String get stopAll => '全部停止';

  @override
  String get searching => '搜索中';

  @override
  String get searchAgain => '重新搜索';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices 台已连接 · $channels 个通道可用';
  }

  @override
  String get turnOnDevices => '打开设备并靠近手机';

  @override
  String get connecting => '连接中';

  @override
  String get disconnect => '断开';

  @override
  String get connect => '连接';

  @override
  String get firstGeneration => '一代电击器';

  @override
  String get secondGeneration => '二代电击器';

  @override
  String channelLabel(String name, String channel) {
    return '$name · $channel 通道';
  }

  @override
  String connectionFailed(String detail) {
    return '连接失败：$detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return '波形测试失败：$detail';
  }

  @override
  String triggerFailed(String detail) {
    return '触发失败：$detail';
  }

  @override
  String stopFailed(String detail) {
    return '关闭失败：$detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return '紧急停止失败：$detail';
  }

  @override
  String get triggeringDevice => '正在触发惩罚设备…';

  @override
  String get minimumGrams => '每轮至少添加 1 克';

  @override
  String remainingGramsLimit(int grams) {
    return '本局最多还能添加 $grams 克';
  }

  @override
  String loadBomb(int grams) {
    return '装填 $grams 克炸弹';
  }

  @override
  String addNumbSeasoning(int count) {
    return '加入麻料 ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return '加入辣料 ×$count';
  }

  @override
  String get keepOriginal => '保留原味';

  @override
  String get sealed => '封装完成';

  @override
  String get playerHasNoDevice => '该玩家未绑定设备';

  @override
  String devicesTriggered(int count) {
    return '已触发 $count 台设备';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '已触发 $succeeded / $attempted 台设备';
  }

  @override
  String get exitGame => '退出游戏';

  @override
  String playerPosition(int current, int total) {
    return '第 $current / $total 位';
  }

  @override
  String get currentPlayer => '现在是';

  @override
  String get pauseAndPass => '暂停并传给下一位';

  @override
  String get readyToTakeOver => '准备接手';

  @override
  String get readyToIgnite => '准备点火';

  @override
  String get handPhoneTo => '把手机交给';

  @override
  String get remainingTime => '剩余时间';

  @override
  String remainingTimeSemantics(String time) {
    return '剩余时间 $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return '累计炸弹：$grams 克 · $flavor';
  }

  @override
  String get seasoningPromptTitle => '这颗炸弹还不够上头';

  @override
  String get seasoningPromptBody => '你加的每一克、每一味，都会留给后面的人';

  @override
  String get addGramsThisTurn => '本轮添加克数';

  @override
  String get grams => '克';

  @override
  String get addNumb => '加麻';

  @override
  String get addSpicy => '加辣';

  @override
  String get takeBomb => '接过炸弹';

  @override
  String get addingSeasoning => '正在添加调料';

  @override
  String get boom => '砰！';

  @override
  String get takePunishment => '接受惩罚';

  @override
  String bombResult(int grams, String flavor) {
    return '$grams 克 · $flavor';
  }

  @override
  String get playAgain => '再来一局';

  @override
  String get resetGame => '重新设置';

  @override
  String get exitRoundTitle => '退出这局？';

  @override
  String get exitRoundBody => '当前倒计时不会保留。';

  @override
  String get continueGame => '继续玩';

  @override
  String get exit => '退出';

  @override
  String get originalFlavor => '原味';

  @override
  String get numbFlavor => '加麻';

  @override
  String numbFlavorCount(int count) {
    return '加麻 ×$count';
  }

  @override
  String get spicyFlavor => '加辣';

  @override
  String spicyFlavorCount(int count) {
    return '加辣 ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return '加麻 ×$numb · 加辣 ×$spicy';
  }
}
