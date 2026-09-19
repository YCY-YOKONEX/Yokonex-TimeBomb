import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nl'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In zh, this message translates to:
  /// **'役次元-时间炸弹'**
  String get appTitle;

  /// No description provided for @language.
  ///
  /// In zh, this message translates to:
  /// **'语言'**
  String get language;

  /// No description provided for @systemLanguage.
  ///
  /// In zh, this message translates to:
  /// **'跟随系统'**
  String get systemLanguage;

  /// No description provided for @playerDefault.
  ///
  /// In zh, this message translates to:
  /// **'玩家 {index}'**
  String playerDefault(int index);

  /// No description provided for @availableChannelsInsufficient.
  ///
  /// In zh, this message translates to:
  /// **'当前只有 {count} 个可用通道，请连接更多设备'**
  String availableChannelsInsufficient(int count);

  /// No description provided for @channelTestsCompleted.
  ///
  /// In zh, this message translates to:
  /// **'已完成 {succeeded} / {total} 个通道测试，请核对并确认'**
  String channelTestsCompleted(int succeeded, int total);

  /// No description provided for @channelTestSuccess.
  ///
  /// In zh, this message translates to:
  /// **'测试完成，请确认玩家与通道是否对应'**
  String get channelTestSuccess;

  /// No description provided for @channelTestFailure.
  ///
  /// In zh, this message translates to:
  /// **'通道测试失败，请检查设备连接'**
  String get channelTestFailure;

  /// No description provided for @completeSafetyTestFirst.
  ///
  /// In zh, this message translates to:
  /// **'请先完成该玩家的安全通道测试'**
  String get completeSafetyTestFirst;

  /// No description provided for @playerNameRequired.
  ///
  /// In zh, this message translates to:
  /// **'请填写每位玩家的名字'**
  String get playerNameRequired;

  /// No description provided for @durationInvalid.
  ///
  /// In zh, this message translates to:
  /// **'游戏时长必须是大于 0 的秒数'**
  String get durationInvalid;

  /// No description provided for @assignmentRequired.
  ///
  /// In zh, this message translates to:
  /// **'每位玩家都必须绑定一个已连接设备的 A/B 通道'**
  String get assignmentRequired;

  /// No description provided for @assignmentTestRequired.
  ///
  /// In zh, this message translates to:
  /// **'每位玩家的通道都必须完成安全测试'**
  String get assignmentTestRequired;

  /// No description provided for @assignmentConfirmRequired.
  ///
  /// In zh, this message translates to:
  /// **'请逐项确认玩家与通道的对应关系'**
  String get assignmentConfirmRequired;

  /// No description provided for @connectDevice.
  ///
  /// In zh, this message translates to:
  /// **'连接电击器'**
  String get connectDevice;

  /// No description provided for @notConnected.
  ///
  /// In zh, this message translates to:
  /// **'尚未连接'**
  String get notConnected;

  /// No description provided for @devicesOnline.
  ///
  /// In zh, this message translates to:
  /// **'{count} 台在线'**
  String devicesOnline(int count);

  /// No description provided for @gameSettings.
  ///
  /// In zh, this message translates to:
  /// **'游戏参数'**
  String get gameSettings;

  /// No description provided for @duration.
  ///
  /// In zh, this message translates to:
  /// **'游戏时长'**
  String get duration;

  /// No description provided for @seconds.
  ///
  /// In zh, this message translates to:
  /// **'秒'**
  String get seconds;

  /// No description provided for @bindPlayers.
  ///
  /// In zh, this message translates to:
  /// **'绑定玩家'**
  String get bindPlayers;

  /// No description provided for @confirmedCount.
  ///
  /// In zh, this message translates to:
  /// **'{confirmed} / {total} 已确认'**
  String confirmedCount(int confirmed, int total);

  /// No description provided for @testingChannels.
  ///
  /// In zh, this message translates to:
  /// **'正在逐个测试'**
  String get testingChannels;

  /// No description provided for @autoAssignAndTest.
  ///
  /// In zh, this message translates to:
  /// **'自动分配并测试'**
  String get autoAssignAndTest;

  /// No description provided for @addPlayer.
  ///
  /// In zh, this message translates to:
  /// **'添加玩家'**
  String get addPlayer;

  /// No description provided for @bindingSummary.
  ///
  /// In zh, this message translates to:
  /// **'已绑定 {assigned} / {total} · 已测试 {tested} / {total} · 已确认 {confirmed} / {total}'**
  String bindingSummary(int assigned, int tested, int confirmed, int total);

  /// No description provided for @startIgnition.
  ///
  /// In zh, this message translates to:
  /// **'开始点火'**
  String get startIgnition;

  /// No description provided for @deviceNeeded.
  ///
  /// In zh, this message translates to:
  /// **'连接设备后才能分配玩家通道'**
  String get deviceNeeded;

  /// No description provided for @channelsAvailable.
  ///
  /// In zh, this message translates to:
  /// **'{name} · A/B 可用'**
  String channelsAvailable(String name);

  /// No description provided for @searchAndConnect.
  ///
  /// In zh, this message translates to:
  /// **'搜索并连接设备'**
  String get searchAndConnect;

  /// No description provided for @manageDevices.
  ///
  /// In zh, this message translates to:
  /// **'管理连接设备'**
  String get manageDevices;

  /// No description provided for @playerHint.
  ///
  /// In zh, this message translates to:
  /// **'玩家 {index}'**
  String playerHint(int index);

  /// No description provided for @removePlayer.
  ///
  /// In zh, this message translates to:
  /// **'删除玩家'**
  String get removePlayer;

  /// No description provided for @deviceChannel.
  ///
  /// In zh, this message translates to:
  /// **'设备通道'**
  String get deviceChannel;

  /// No description provided for @unassigned.
  ///
  /// In zh, this message translates to:
  /// **'未绑定'**
  String get unassigned;

  /// No description provided for @testing.
  ///
  /// In zh, this message translates to:
  /// **'测试中'**
  String get testing;

  /// No description provided for @retest.
  ///
  /// In zh, this message translates to:
  /// **'重新测试'**
  String get retest;

  /// No description provided for @safetyTest.
  ///
  /// In zh, this message translates to:
  /// **'安全测试'**
  String get safetyTest;

  /// No description provided for @confirmed.
  ///
  /// In zh, this message translates to:
  /// **'已确认'**
  String get confirmed;

  /// No description provided for @confirmAssignment.
  ///
  /// In zh, this message translates to:
  /// **'确认绑定'**
  String get confirmAssignment;

  /// No description provided for @punishmentDevices.
  ///
  /// In zh, this message translates to:
  /// **'惩罚设备'**
  String get punishmentDevices;

  /// No description provided for @stopAll.
  ///
  /// In zh, this message translates to:
  /// **'全部停止'**
  String get stopAll;

  /// No description provided for @searching.
  ///
  /// In zh, this message translates to:
  /// **'搜索中'**
  String get searching;

  /// No description provided for @searchAgain.
  ///
  /// In zh, this message translates to:
  /// **'重新搜索'**
  String get searchAgain;

  /// No description provided for @connectionSummary.
  ///
  /// In zh, this message translates to:
  /// **'{devices} 台已连接 · {channels} 个通道可用'**
  String connectionSummary(int devices, int channels);

  /// No description provided for @turnOnDevices.
  ///
  /// In zh, this message translates to:
  /// **'打开设备并靠近手机'**
  String get turnOnDevices;

  /// No description provided for @connecting.
  ///
  /// In zh, this message translates to:
  /// **'连接中'**
  String get connecting;

  /// No description provided for @disconnect.
  ///
  /// In zh, this message translates to:
  /// **'断开'**
  String get disconnect;

  /// No description provided for @connect.
  ///
  /// In zh, this message translates to:
  /// **'连接'**
  String get connect;

  /// No description provided for @firstGeneration.
  ///
  /// In zh, this message translates to:
  /// **'一代电击器'**
  String get firstGeneration;

  /// No description provided for @secondGeneration.
  ///
  /// In zh, this message translates to:
  /// **'二代电击器'**
  String get secondGeneration;

  /// No description provided for @channelLabel.
  ///
  /// In zh, this message translates to:
  /// **'{name} · {channel} 通道'**
  String channelLabel(String name, String channel);

  /// No description provided for @connectionFailed.
  ///
  /// In zh, this message translates to:
  /// **'连接失败：{detail}'**
  String connectionFailed(String detail);

  /// No description provided for @waveformTestFailed.
  ///
  /// In zh, this message translates to:
  /// **'波形测试失败：{detail}'**
  String waveformTestFailed(String detail);

  /// No description provided for @triggerFailed.
  ///
  /// In zh, this message translates to:
  /// **'触发失败：{detail}'**
  String triggerFailed(String detail);

  /// No description provided for @stopFailed.
  ///
  /// In zh, this message translates to:
  /// **'关闭失败：{detail}'**
  String stopFailed(String detail);

  /// No description provided for @emergencyStopFailed.
  ///
  /// In zh, this message translates to:
  /// **'紧急停止失败：{detail}'**
  String emergencyStopFailed(String detail);

  /// No description provided for @triggeringDevice.
  ///
  /// In zh, this message translates to:
  /// **'正在触发惩罚设备…'**
  String get triggeringDevice;

  /// No description provided for @minimumGrams.
  ///
  /// In zh, this message translates to:
  /// **'每轮至少添加 1 克'**
  String get minimumGrams;

  /// No description provided for @remainingGramsLimit.
  ///
  /// In zh, this message translates to:
  /// **'本局最多还能添加 {grams} 克'**
  String remainingGramsLimit(int grams);

  /// No description provided for @loadBomb.
  ///
  /// In zh, this message translates to:
  /// **'装填 {grams} 克炸弹'**
  String loadBomb(int grams);

  /// No description provided for @addNumbSeasoning.
  ///
  /// In zh, this message translates to:
  /// **'加入麻料 ×{count}'**
  String addNumbSeasoning(int count);

  /// No description provided for @addSpicySeasoning.
  ///
  /// In zh, this message translates to:
  /// **'加入辣料 ×{count}'**
  String addSpicySeasoning(int count);

  /// No description provided for @keepOriginal.
  ///
  /// In zh, this message translates to:
  /// **'保留原味'**
  String get keepOriginal;

  /// No description provided for @sealed.
  ///
  /// In zh, this message translates to:
  /// **'封装完成'**
  String get sealed;

  /// No description provided for @playerHasNoDevice.
  ///
  /// In zh, this message translates to:
  /// **'该玩家未绑定设备'**
  String get playerHasNoDevice;

  /// No description provided for @devicesTriggered.
  ///
  /// In zh, this message translates to:
  /// **'已触发 {count} 台设备'**
  String devicesTriggered(int count);

  /// No description provided for @devicesTriggeredPartial.
  ///
  /// In zh, this message translates to:
  /// **'已触发 {succeeded} / {attempted} 台设备'**
  String devicesTriggeredPartial(int succeeded, int attempted);

  /// No description provided for @exitGame.
  ///
  /// In zh, this message translates to:
  /// **'退出游戏'**
  String get exitGame;

  /// No description provided for @playerPosition.
  ///
  /// In zh, this message translates to:
  /// **'第 {current} / {total} 位'**
  String playerPosition(int current, int total);

  /// No description provided for @currentPlayer.
  ///
  /// In zh, this message translates to:
  /// **'现在是'**
  String get currentPlayer;

  /// No description provided for @pauseAndPass.
  ///
  /// In zh, this message translates to:
  /// **'暂停并传给下一位'**
  String get pauseAndPass;

  /// No description provided for @readyToTakeOver.
  ///
  /// In zh, this message translates to:
  /// **'准备接手'**
  String get readyToTakeOver;

  /// No description provided for @readyToIgnite.
  ///
  /// In zh, this message translates to:
  /// **'准备点火'**
  String get readyToIgnite;

  /// No description provided for @handPhoneTo.
  ///
  /// In zh, this message translates to:
  /// **'把手机交给'**
  String get handPhoneTo;

  /// No description provided for @remainingTime.
  ///
  /// In zh, this message translates to:
  /// **'剩余时间'**
  String get remainingTime;

  /// No description provided for @remainingTimeSemantics.
  ///
  /// In zh, this message translates to:
  /// **'剩余时间 {time}'**
  String remainingTimeSemantics(String time);

  /// No description provided for @bombTotal.
  ///
  /// In zh, this message translates to:
  /// **'累计炸弹：{grams} 克 · {flavor}'**
  String bombTotal(int grams, String flavor);

  /// No description provided for @seasoningPromptTitle.
  ///
  /// In zh, this message translates to:
  /// **'这颗炸弹还不够上头'**
  String get seasoningPromptTitle;

  /// No description provided for @seasoningPromptBody.
  ///
  /// In zh, this message translates to:
  /// **'你加的每一克、每一味，都会留给后面的人'**
  String get seasoningPromptBody;

  /// No description provided for @addGramsThisTurn.
  ///
  /// In zh, this message translates to:
  /// **'本轮添加克数'**
  String get addGramsThisTurn;

  /// No description provided for @grams.
  ///
  /// In zh, this message translates to:
  /// **'克'**
  String get grams;

  /// No description provided for @addNumb.
  ///
  /// In zh, this message translates to:
  /// **'加麻'**
  String get addNumb;

  /// No description provided for @addSpicy.
  ///
  /// In zh, this message translates to:
  /// **'加辣'**
  String get addSpicy;

  /// No description provided for @takeBomb.
  ///
  /// In zh, this message translates to:
  /// **'接过炸弹'**
  String get takeBomb;

  /// No description provided for @addingSeasoning.
  ///
  /// In zh, this message translates to:
  /// **'正在添加调料'**
  String get addingSeasoning;

  /// No description provided for @boom.
  ///
  /// In zh, this message translates to:
  /// **'砰！'**
  String get boom;

  /// No description provided for @takePunishment.
  ///
  /// In zh, this message translates to:
  /// **'接受惩罚'**
  String get takePunishment;

  /// No description provided for @bombResult.
  ///
  /// In zh, this message translates to:
  /// **'{grams} 克 · {flavor}'**
  String bombResult(int grams, String flavor);

  /// No description provided for @playAgain.
  ///
  /// In zh, this message translates to:
  /// **'再来一局'**
  String get playAgain;

  /// No description provided for @resetGame.
  ///
  /// In zh, this message translates to:
  /// **'重新设置'**
  String get resetGame;

  /// No description provided for @exitRoundTitle.
  ///
  /// In zh, this message translates to:
  /// **'退出这局？'**
  String get exitRoundTitle;

  /// No description provided for @exitRoundBody.
  ///
  /// In zh, this message translates to:
  /// **'当前倒计时不会保留。'**
  String get exitRoundBody;

  /// No description provided for @continueGame.
  ///
  /// In zh, this message translates to:
  /// **'继续玩'**
  String get continueGame;

  /// No description provided for @exit.
  ///
  /// In zh, this message translates to:
  /// **'退出'**
  String get exit;

  /// No description provided for @originalFlavor.
  ///
  /// In zh, this message translates to:
  /// **'原味'**
  String get originalFlavor;

  /// No description provided for @numbFlavor.
  ///
  /// In zh, this message translates to:
  /// **'加麻'**
  String get numbFlavor;

  /// No description provided for @numbFlavorCount.
  ///
  /// In zh, this message translates to:
  /// **'加麻 ×{count}'**
  String numbFlavorCount(int count);

  /// No description provided for @spicyFlavor.
  ///
  /// In zh, this message translates to:
  /// **'加辣'**
  String get spicyFlavor;

  /// No description provided for @spicyFlavorCount.
  ///
  /// In zh, this message translates to:
  /// **'加辣 ×{count}'**
  String spicyFlavorCount(int count);

  /// No description provided for @mixedFlavor.
  ///
  /// In zh, this message translates to:
  /// **'加麻 ×{numb} · 加辣 ×{spicy}'**
  String mixedFlavor(int numb, int spicy);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'de',
    'en',
    'es',
    'fr',
    'it',
    'ja',
    'ko',
    'nl',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'nl':
      return AppLocalizationsNl();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
