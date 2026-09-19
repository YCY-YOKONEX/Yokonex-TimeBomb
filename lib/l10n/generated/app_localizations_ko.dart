// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => 'Yokonex 타임 봄';

  @override
  String get language => '언어';

  @override
  String get systemLanguage => '시스템 언어 사용';

  @override
  String playerDefault(int index) {
    return '플레이어 $index';
  }

  @override
  String availableChannelsInsufficient(int count) {
    return '사용 가능한 채널이 $count개뿐입니다. 장치를 더 연결하세요.';
  }

  @override
  String channelTestsCompleted(int succeeded, int total) {
    return '채널 $succeeded / $total개를 테스트했습니다. 확인 후 승인하세요.';
  }

  @override
  String get channelTestSuccess => '테스트 완료. 플레이어와 채널이 맞는지 확인하세요.';

  @override
  String get channelTestFailure => '채널 테스트에 실패했습니다. 장치 연결을 확인하세요.';

  @override
  String get completeSafetyTestFirst => '먼저 이 플레이어의 안전 테스트를 완료하세요.';

  @override
  String get playerNameRequired => '모든 플레이어의 이름을 입력하세요.';

  @override
  String get durationInvalid => '게임 시간은 0초보다 커야 합니다.';

  @override
  String get assignmentRequired => '모든 플레이어에게 연결된 장치의 A/B 채널을 지정하세요.';

  @override
  String get assignmentTestRequired => '모든 플레이어 채널이 안전 테스트를 통과해야 합니다.';

  @override
  String get assignmentConfirmRequired => '모든 플레이어와 채널 연결을 확인하세요.';

  @override
  String get connectDevice => '장치 연결';

  @override
  String get notConnected => '연결 안 됨';

  @override
  String devicesOnline(int count) {
    return '$count대 온라인';
  }

  @override
  String get gameSettings => '게임 설정';

  @override
  String get duration => '게임 시간';

  @override
  String get seconds => '초';

  @override
  String get bindPlayers => '플레이어 지정';

  @override
  String confirmedCount(int confirmed, int total) {
    return '$confirmed / $total 확인됨';
  }

  @override
  String get testingChannels => '채널 테스트 중';

  @override
  String get autoAssignAndTest => '자동 지정 및 테스트';

  @override
  String get addPlayer => '플레이어 추가';

  @override
  String bindingSummary(int assigned, int tested, int confirmed, int total) {
    return '지정 $assigned / $total · 테스트 $tested / $total · 확인 $confirmed / $total';
  }

  @override
  String get startIgnition => '점화 시작';

  @override
  String get deviceNeeded => '플레이어 채널을 지정하기 전에 장치를 연결하세요.';

  @override
  String channelsAvailable(String name) {
    return '$name · A/B 사용 가능';
  }

  @override
  String get searchAndConnect => '장치 검색 및 연결';

  @override
  String get manageDevices => '장치 관리';

  @override
  String playerHint(int index) {
    return '플레이어 $index';
  }

  @override
  String get removePlayer => '플레이어 삭제';

  @override
  String get deviceChannel => '장치 채널';

  @override
  String get unassigned => '지정 안 됨';

  @override
  String get testing => '테스트 중';

  @override
  String get retest => '다시 테스트';

  @override
  String get safetyTest => '안전 테스트';

  @override
  String get confirmed => '확인됨';

  @override
  String get confirmAssignment => '확인';

  @override
  String get punishmentDevices => '벌칙 장치';

  @override
  String get stopAll => '모두 정지';

  @override
  String get searching => '검색 중';

  @override
  String get searchAgain => '다시 검색';

  @override
  String connectionSummary(int devices, int channels) {
    return '$devices대 연결 · $channels개 채널 사용 가능';
  }

  @override
  String get turnOnDevices => '장치를 켜고 휴대전화 가까이에 두세요.';

  @override
  String get connecting => '연결 중';

  @override
  String get disconnect => '연결 해제';

  @override
  String get connect => '연결';

  @override
  String get firstGeneration => '1세대';

  @override
  String get secondGeneration => '2세대';

  @override
  String channelLabel(String name, String channel) {
    return '$name · $channel 채널';
  }

  @override
  String connectionFailed(String detail) {
    return '연결 실패: $detail';
  }

  @override
  String waveformTestFailed(String detail) {
    return '파형 테스트 실패: $detail';
  }

  @override
  String triggerFailed(String detail) {
    return '작동 실패: $detail';
  }

  @override
  String stopFailed(String detail) {
    return '정지 실패: $detail';
  }

  @override
  String emergencyStopFailed(String detail) {
    return '긴급 정지 실패: $detail';
  }

  @override
  String get triggeringDevice => '벌칙 장치 작동 중…';

  @override
  String get minimumGrams => '매 턴 최소 1그램을 추가하세요.';

  @override
  String remainingGramsLimit(int grams) {
    return '이번 게임에서 최대 $grams그램을 더 추가할 수 있습니다.';
  }

  @override
  String loadBomb(int grams) {
    return '${grams}g 폭탄 장전 중';
  }

  @override
  String addNumbSeasoning(int count) {
    return '얼얼함 추가 ×$count';
  }

  @override
  String addSpicySeasoning(int count) {
    return '매운맛 추가 ×$count';
  }

  @override
  String get keepOriginal => '기본 맛 유지';

  @override
  String get sealed => '폭탄 밀봉 완료';

  @override
  String get playerHasNoDevice => '이 플레이어에게 지정된 장치가 없습니다.';

  @override
  String devicesTriggered(int count) {
    return '장치 $count대 작동';
  }

  @override
  String devicesTriggeredPartial(int succeeded, int attempted) {
    return '장치 $succeeded / $attempted대 작동';
  }

  @override
  String get exitGame => '게임 나가기';

  @override
  String playerPosition(int current, int total) {
    return '플레이어 $current / $total';
  }

  @override
  String get currentPlayer => '현재 플레이어';

  @override
  String get pauseAndPass => '일시 정지 후 넘기기';

  @override
  String get readyToTakeOver => '준비하세요';

  @override
  String get readyToIgnite => '점화 준비';

  @override
  String get handPhoneTo => '휴대전화를 넘겨주세요';

  @override
  String get remainingTime => '남은 시간';

  @override
  String remainingTimeSemantics(String time) {
    return '남은 시간 $time';
  }

  @override
  String bombTotal(int grams, String flavor) {
    return '누적 폭탄: ${grams}g · $flavor';
  }

  @override
  String get seasoningPromptTitle => '이 폭탄은 아직 자극이 부족해요';

  @override
  String get seasoningPromptBody => '추가한 모든 무게와 맛은 다음 플레이어에게 남습니다.';

  @override
  String get addGramsThisTurn => '이번 턴 추가 무게';

  @override
  String get grams => 'g';

  @override
  String get addNumb => '얼얼함 추가';

  @override
  String get addSpicy => '매운맛 추가';

  @override
  String get takeBomb => '폭탄 받기';

  @override
  String get addingSeasoning => '양념 추가 중';

  @override
  String get boom => '펑!';

  @override
  String get takePunishment => '벌칙 받기';

  @override
  String bombResult(int grams, String flavor) {
    return '${grams}g · $flavor';
  }

  @override
  String get playAgain => '다시 하기';

  @override
  String get resetGame => '설정 변경';

  @override
  String get exitRoundTitle => '게임을 종료할까요?';

  @override
  String get exitRoundBody => '현재 카운트다운이 사라집니다.';

  @override
  String get continueGame => '계속하기';

  @override
  String get exit => '나가기';

  @override
  String get originalFlavor => '기본 맛';

  @override
  String get numbFlavor => '얼얼함';

  @override
  String numbFlavorCount(int count) {
    return '얼얼함 ×$count';
  }

  @override
  String get spicyFlavor => '매운맛';

  @override
  String spicyFlavorCount(int count) {
    return '매운맛 ×$count';
  }

  @override
  String mixedFlavor(int numb, int spicy) {
    return '얼얼함 ×$numb · 매운맛 ×$spicy';
  }
}
