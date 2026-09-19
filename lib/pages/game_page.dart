import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ems/ems_controller.dart';
import '../game/bomb_round.dart';
import '../game/player_bomb_settings.dart';
import '../l10n/l10n.dart';
import '../main.dart';

enum _ExplosionStage { seasoning, blast, result }

class GamePage extends StatefulWidget {
  const GamePage({required this.players, required this.duration, super.key});

  final List<String> players;
  final Duration duration;

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  static const _hapticsChannel = MethodChannel('time_bomb/haptics');

  late final BombRound _round;
  late final PlayerBombSettings _bombSettings;
  late final AnimationController _dangerController;
  late final AnimationController _explosionController;
  Timer? _timer;
  Timer? _launchTimer;
  DateTime? _lastTick;
  int _launchCount = 0;
  int _lastDangerSecond = -1;
  bool _punishmentTriggered = false;
  String? _punishmentStatus;
  _ExplosionStage _explosionStage = _ExplosionStage.seasoning;
  int _seasoningStep = 0;
  int _explosionSequenceId = 0;
  bool _pendingNumb = false;
  bool _pendingSpicy = false;
  String _pendingGrams = '1';
  bool _pendingGramsPristine = true;
  String? _setupError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _dangerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    )..repeat(reverse: true);
    _explosionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );
    _round = BombRound(
      players: List.unmodifiable(widget.players),
      totalDuration: widget.duration,
    );
    _bombSettings = PlayerBombSettings();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _launchTimer?.cancel();
    _explosionSequenceId++;
    unawaited(EmsController.instance.stopAll());
    _dangerController.dispose();
    _explosionController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        _round.phase == BombPhase.running) {
      _tick();
    } else if (state != AppLifecycleState.resumed) {
      // 离开前台时立即关闭所有设备，避免后台期间持续输出。
      unawaited(EmsController.instance.stopAll());
    }
  }

  void _startOrResumeRound() {
    if (_round.phase == BombPhase.ready) {
      _round.start();
    } else {
      _round.resume();
    }
    _lastDangerSecond = -1;
    _startTimer();
  }

  void _beginLaunch() {
    _launchTimer?.cancel();
    setState(() => _launchCount = 3);
    HapticFeedback.heavyImpact();
    _launchTimer = Timer.periodic(const Duration(milliseconds: 520), (timer) {
      if (!mounted) return;
      if (_launchCount <= 1) {
        timer.cancel();
        setState(() => _launchCount = 0);
        _startOrResumeRound();
        return;
      }
      setState(() => _launchCount--);
      HapticFeedback.mediumImpact();
    });
  }

  void _submitPlayerSetup() {
    final amount = int.tryParse(_pendingGrams);
    if (amount == null || amount < 1) {
      setState(() => _setupError = context.l10n.minimumGrams);
      return;
    }
    if (amount > _bombSettings.remainingGrams) {
      setState(() {
        _setupError = context.l10n.remainingGramsLimit(
          _bombSettings.remainingGrams,
        );
      });
      return;
    }

    // 玩家确认接手时，才把本轮选择正式累加到整局炸弹配置。
    _bombSettings.addGrams(amount);
    if (_pendingNumb) _bombSettings.addNumb();
    if (_pendingSpicy) _bombSettings.addSpicy();
    _pendingGrams = '1';
    _pendingGramsPristine = true;
    _pendingNumb = false;
    _pendingSpicy = false;
    _setupError = null;
    _beginLaunch();
  }

  void _enterGramDigit(int digit) {
    final next =
        _pendingGramsPristine || _pendingGrams.isEmpty || _pendingGrams == '0'
        ? '$digit'
        : '$_pendingGrams$digit';
    if (next.length > 3) return;
    HapticFeedback.selectionClick();
    setState(() {
      _pendingGrams = next;
      _pendingGramsPristine = false;
      _setupError = null;
    });
  }

  void _clearPendingGrams() {
    HapticFeedback.selectionClick();
    setState(() {
      _pendingGrams = '';
      _pendingGramsPristine = false;
      _setupError = null;
    });
  }

  void _removePendingGramDigit() {
    if (_pendingGrams.isEmpty) return;
    HapticFeedback.selectionClick();
    setState(() {
      _pendingGrams = _pendingGrams.substring(0, _pendingGrams.length - 1);
      _pendingGramsPristine = false;
      _setupError = null;
    });
  }

  void _startTimer() {
    _lastTick = DateTime.now();
    _timer?.cancel();
    // 使用接近屏幕刷新率的频率，让毫秒和危险动画保持连贯。
    _timer = Timer.periodic(const Duration(milliseconds: 16), (_) => _tick());
    if (mounted) setState(() {});
  }

  void _tick() {
    if (!mounted || _round.phase != BombPhase.running) return;
    final now = DateTime.now();
    final lastTick = _lastTick ?? now;
    _lastTick = now;
    _round.elapse(now.difference(lastTick));

    final dangerSecond = _round.remaining.inSeconds;
    if (dangerSecond <= 10 && dangerSecond != _lastDangerSecond) {
      _lastDangerSecond = dangerSecond;
      HapticFeedback.selectionClick();
    }

    if (_round.phase == BombPhase.finished) {
      _timer?.cancel();
      if (!_punishmentTriggered) {
        unawaited(_beginExplosionSequence());
      }
    }
    setState(() {});
  }

  void _pauseAndPass() {
    _tick();
    if (_round.phase != BombPhase.running) return;
    _timer?.cancel();
    _round.pauseAndPass();
    SystemSound.play(SystemSoundType.click);
    HapticFeedback.mediumImpact();
    setState(() {});
  }

  void _restart() {
    _round.restart();
    _bombSettings.reset();
    _pendingGrams = '1';
    _pendingGramsPristine = true;
    _pendingNumb = false;
    _pendingSpicy = false;
    _setupError = null;
    _explosionSequenceId++;
    _punishmentTriggered = false;
    _punishmentStatus = null;
    _explosionStage = _ExplosionStage.seasoning;
    _seasoningStep = 0;
    _explosionController.reset();
    setState(() {});
  }

  Future<void> _beginExplosionSequence() async {
    if (_punishmentTriggered) return;
    _punishmentTriggered = true;
    final sequenceId = ++_explosionSequenceId;
    final items = _seasoningItems(context.l10n, _bombSettings);

    _explosionStage = _ExplosionStage.seasoning;
    _seasoningStep = 0;
    setState(() {});

    // 按玩家选择逐项装填，让最终爆炸和本轮配置建立清楚联系。
    for (var index = 0; index < items.length; index++) {
      if (!mounted || sequenceId != _explosionSequenceId) return;
      setState(() => _seasoningStep = index);
      unawaited(HapticFeedback.selectionClick());
      await Future<void>.delayed(const Duration(milliseconds: 620));
    }
    if (!mounted || sequenceId != _explosionSequenceId) return;

    setState(() => _explosionStage = _ExplosionStage.blast);
    _playExplosionSound();
    unawaited(_triggerPunishment());
    unawaited(_playDetonationHaptics(sequenceId));
    try {
      await _explosionController.forward(from: 0).orCancel;
    } on TickerCanceled {
      return;
    }
    if (!mounted || sequenceId != _explosionSequenceId) return;
    setState(() => _explosionStage = _ExplosionStage.result);
  }

  // 爆炸瞬间播放系统警报音，并叠加震动，确保声音关闭时仍有明显反馈。
  void _playExplosionSound() {
    SystemSound.play(SystemSoundType.alert);
  }

  Future<void> _playDetonationHaptics(int sequenceId) async {
    try {
      // Android 使用原生波形，确保 release 包也能稳定触发震动。
      await _hapticsChannel.invokeMethod<void>('detonation');
      return;
    } on MissingPluginException {
      // 非 Android 平台继续使用 Flutter 的通用触感接口。
    } on PlatformException {
      // 原生通道不可用时保留通用触感兜底，避免爆炸完全没有反馈。
    }
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 90));
    if (!mounted || sequenceId != _explosionSequenceId) return;
    await HapticFeedback.vibrate();
    await Future<void>.delayed(const Duration(milliseconds: 140));
    if (!mounted || sequenceId != _explosionSequenceId) return;
    await HapticFeedback.heavyImpact();
    await Future<void>.delayed(const Duration(milliseconds: 180));
    if (!mounted || sequenceId != _explosionSequenceId) return;
    await HapticFeedback.mediumImpact();
  }

  List<_SeasoningItem> _seasoningItems(
    AppLocalizations l10n,
    PlayerBombSettings settings,
  ) {
    return [
      _SeasoningItem(
        icon: Icons.scale_rounded,
        label: l10n.loadBomb(settings.grams),
        color: TimeBombApp.signalYellow,
      ),
      if (settings.numbCount > 0)
        _SeasoningItem(
          icon: Icons.bolt_rounded,
          label: l10n.addNumbSeasoning(settings.numbCount),
          color: TimeBombApp.mint,
        ),
      if (settings.spicyCount > 0)
        _SeasoningItem(
          icon: Icons.local_fire_department_rounded,
          label: l10n.addSpicySeasoning(settings.spicyCount),
          color: TimeBombApp.warningRed,
        ),
      if (settings.numbCount == 0 && settings.spicyCount == 0)
        _SeasoningItem(
          icon: Icons.restaurant_rounded,
          label: l10n.keepOriginal,
          color: Colors.white70,
        ),
      _SeasoningItem(
        icon: Icons.lock_rounded,
        label: l10n.sealed,
        color: TimeBombApp.signalYellow,
      ),
    ];
  }

  Future<void> _triggerPunishment() async {
    final report = await EmsController.instance.triggerForPlayer(
      playerIndex: _round.currentPlayerIndex,
      bombGrams: _bombSettings.grams,
      frequency: _bombSettings.frequency,
    );
    if (!mounted) return;
    setState(() {
      if (report.attempted == 0) {
        _punishmentStatus = context.l10n.playerHasNoDevice;
      } else if (report.succeeded == report.attempted) {
        _punishmentStatus = context.l10n.devicesTriggered(report.succeeded);
      } else {
        _punishmentStatus = context.l10n.devicesTriggeredPartial(
          report.succeeded,
          report.attempted,
        );
      }
    });
  }

  String get _timeLabel {
    final totalMilliseconds = _round.remaining.inMilliseconds.clamp(0, 999999);
    final seconds = totalMilliseconds ~/ 1000;
    final milliseconds = totalMilliseconds % 1000;
    return '${seconds.toString().padLeft(3, '0')}.'
        '${milliseconds.toString().padLeft(3, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _round.phase == BombPhase.finished,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _confirmExit();
      },
      child: Scaffold(
        backgroundColor: TimeBombApp.coal,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 240),
            child: _launchCount > 0
                ? _buildLaunchCountdown()
                : switch (_round.phase) {
                    BombPhase.ready => _buildPlayerSetup(firstTurn: true),
                    BombPhase.handoff => _buildPlayerSetup(firstTurn: false),
                    BombPhase.finished => _buildFinishedFlow(),
                    BombPhase.running => _buildRunning(),
                  },
          ),
        ),
      ),
    );
  }

  Widget _buildRunning() {
    final remaining = _round.remaining;
    final urgent = remaining <= const Duration(seconds: 10);
    final critical = remaining <= const Duration(seconds: 5);
    return AnimatedBuilder(
      animation: _dangerController,
      builder: (context, child) {
        final pulse = Curves.easeInOut.transform(_dangerController.value);
        final background = urgent
            ? Color.lerp(
                TimeBombApp.coal,
                const Color(0xFF4B1717),
                pulse * (critical ? 0.48 : 0.28),
              )!
            : TimeBombApp.coal;
        return Stack(
          fit: StackFit.expand,
          children: [
            ColoredBox(color: background),
            if (critical)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _DangerVeilPainter(animation: pulse),
                  ),
                ),
              ),
            child!,
          ],
        );
      },
      child: Center(
        key: const ValueKey('running'),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 24),
            child: Column(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: _confirmExit,
                      tooltip: context.l10n.exitGame,
                      color: Colors.white70,
                      icon: const Icon(Icons.close_rounded),
                    ),
                    const Spacer(),
                    Text(
                      context.l10n.playerPosition(
                        _round.currentPlayerIndex + 1,
                        _round.players.length,
                      ),
                      style: const TextStyle(
                        color: Colors.white60,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Text(
                  context.l10n.currentPlayer,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.65),
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _round.currentPlayer,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 34,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  flex: 5,
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: AnimatedBuilder(
                      animation: _dangerController,
                      builder: (context, child) {
                        final wave = Curves.easeInOut.transform(
                          _dangerController.value,
                        );
                        final shake = urgent
                            ? math.sin(
                                    _dangerController.value *
                                        math.pi *
                                        (critical ? 12 : 8),
                                  ) *
                                  (critical ? 10 : 4)
                            : 0.0;
                        final scale = urgent
                            ? 1 + wave * (critical ? 0.085 : 0.045)
                            : 1.0;
                        final rotation = critical
                            ? math.sin(_dangerController.value * math.pi * 6) *
                                  0.022
                            : 0.0;

                        // 最后五秒再提高运动幅度，让临爆前的危险感明显升级。
                        return Transform.rotate(
                          angle: rotation,
                          child: Transform.translate(
                            offset: Offset(shake, 0),
                            child: Transform.scale(
                              scale: scale,
                              child: CustomPaint(
                                painter: _BombPainter(
                                  urgent: urgent,
                                  critical: critical,
                                  animation: wave,
                                ),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.bolt_rounded,
                                      color: urgent
                                          ? TimeBombApp.signalYellow
                                          : Colors.white,
                                      size: critical ? 98 : 92,
                                      shadows: urgent
                                          ? [
                                              Shadow(
                                                color: TimeBombApp.signalYellow
                                                    .withValues(
                                                      alpha: critical
                                                          ? 0.55 + wave * 0.4
                                                          : 0.35 + wave * 0.4,
                                                    ),
                                                blurRadius: critical
                                                    ? 22 + wave * 28
                                                    : 16 + wave * 18,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    // 交接动作放在炸弹中心，玩家无需在屏幕底部寻找按钮。
                                    Semantics(
                                      button: true,
                                      label: context.l10n.pauseAndPass,
                                      child: SizedBox(
                                        width: 148,
                                        height: 76,
                                        child: FilledButton(
                                          onPressed: _pauseAndPass,
                                          style: FilledButton.styleFrom(
                                            backgroundColor:
                                                TimeBombApp.warningRed,
                                            foregroundColor: Colors.white,
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              side: const BorderSide(
                                                color: Colors.white,
                                                width: 2,
                                              ),
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              const Text(
                                                '拍！',
                                                style: TextStyle(
                                                  fontSize: 30,
                                                  fontWeight: FontWeight.w900,
                                                ),
                                              ),
                                              Opacity(
                                                opacity: 0,
                                                child: Text(
                                                  context.l10n.pauseAndPass,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLaunchCountdown() {
    return ColoredBox(
      key: const ValueKey('launch'),
      color: TimeBombApp.coal,
      child: Center(
        child: TweenAnimationBuilder<double>(
          key: ValueKey(_launchCount),
          tween: Tween(begin: 1.35, end: 1),
          duration: const Duration(milliseconds: 480),
          curve: Curves.easeOut,
          builder: (context, scale, child) {
            return Transform.scale(scale: scale, child: child);
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.readyToTakeOver,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                '$_launchCount',
                style: const TextStyle(
                  color: TimeBombApp.signalYellow,
                  fontSize: 132,
                  height: 0.95,
                  fontWeight: FontWeight.w900,
                  fontFeatures: [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(height: 18),
              Text(
                _round.currentPlayer,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlayerSetup({required bool firstTurn}) {
    final pendingSeasoningCount =
        (_pendingNumb ? 1 : 0) + (_pendingSpicy ? 1 : 0);
    final canSelectMoreSeasoning =
        _bombSettings.seasoningCount + pendingSeasoningCount <
        PlayerBombSettings.maxSeasoningCount;
    return Container(
      key: ValueKey(firstTurn ? 'player-setup' : 'handoff'),
      color: TimeBombApp.signalYellow,
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // 平板横屏高度有限，交接信息和操作区改为左右排列，避免底部按钮被挡住。
          final useLandscapeLayout =
              constraints.maxWidth >= 900 && constraints.maxHeight < 850;
          final summary = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                firstTurn
                    ? Icons.local_fire_department_rounded
                    : Icons.pan_tool_alt_rounded,
                size: 58,
              ),
              const SizedBox(height: 14),
              Text(
                firstTurn
                    ? context.l10n.readyToIgnite
                    : context.l10n.handPhoneTo,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                _round.currentPlayer,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (!firstTurn) ...[
                const SizedBox(height: 10),
                // 交接时公开剩余时间，玩家持有炸弹期间仍保持未知。
                Text(
                  context.l10n.remainingTime,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _timeLabel,
                  key: const ValueKey('remaining-time'),
                  textAlign: TextAlign.center,
                  semanticsLabel: context.l10n.remainingTimeSemantics(
                    _timeLabel,
                  ),
                  style: const TextStyle(
                    fontSize: 48,
                    height: 1,
                    fontWeight: FontWeight.w900,
                    fontFeatures: [FontFeature.tabularFigures()],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Text(
                context.l10n.bombTotal(
                  _bombSettings.grams,
                  context.l10n.flavorLabel(_bombSettings),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                context.l10n.seasoningPromptTitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                context.l10n.seasoningPromptBody,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
          final controls = Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _GramKeypad(
                value: _pendingGrams,
                label: context.l10n.addGramsThisTurn,
                unit: context.l10n.grams,
                onDigit: _enterGramDigit,
                onClear: _clearPendingGrams,
                onBackspace: _removePendingGramDigit,
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  Expanded(
                    child: _SeasoningToggle(
                      label: context.l10n.addNumb,
                      icon: Icons.bolt_rounded,
                      selected: _pendingNumb,
                      enabled: _pendingNumb || canSelectMoreSeasoning,
                      onChanged: (value) {
                        setState(() => _pendingNumb = value);
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _SeasoningToggle(
                      label: context.l10n.addSpicy,
                      icon: Icons.local_fire_department_rounded,
                      selected: _pendingSpicy,
                      enabled: _pendingSpicy || canSelectMoreSeasoning,
                      onChanged: (value) {
                        setState(() => _pendingSpicy = value);
                      },
                    ),
                  ),
                ],
              ),
              if (_setupError != null) ...[
                const SizedBox(height: 10),
                Text(
                  _setupError!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TimeBombApp.warningRed,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _submitPlayerSetup,
                style: FilledButton.styleFrom(
                  backgroundColor: TimeBombApp.coal,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(
                  firstTurn
                      ? context.l10n.startIgnition
                      : context.l10n.takeBomb,
                ),
              ),
            ],
          );

          return Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: useLandscapeLayout ? 1040 : 640,
              ),
              child: useLandscapeLayout
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(child: summary),
                        const SizedBox(width: 40),
                        Expanded(child: controls),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          summary,
                          const SizedBox(height: 14),
                          controls,
                        ],
                      ),
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFinishedFlow() {
    return switch (_explosionStage) {
      _ExplosionStage.seasoning => _buildSeasoningSequence(),
      _ExplosionStage.blast => _buildExplosion(),
      _ExplosionStage.result => _buildResult(),
    };
  }

  Widget _buildSeasoningSequence() {
    final items = _seasoningItems(context.l10n, _bombSettings);
    final currentItem = items[_seasoningStep.clamp(0, items.length - 1)];

    return ColoredBox(
      key: const ValueKey('seasoning'),
      color: TimeBombApp.coal,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  context.l10n.addingSeasoning,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _round.currentPlayer,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 30),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 260),
                  transitionBuilder: (child, animation) {
                    return ScaleTransition(
                      scale: CurvedAnimation(
                        parent: animation,
                        curve: Curves.easeOutBack,
                      ),
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: Container(
                    key: ValueKey(_seasoningStep),
                    width: 132,
                    height: 132,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: currentItem.color,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Icon(
                      currentItem.icon,
                      size: 68,
                      color: TimeBombApp.coal,
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  currentItem.label,
                  key: const ValueKey('seasoning-current'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: TimeBombApp.signalYellow,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 28),
                ...List.generate(items.length, (index) {
                  final item = items[index];
                  final completed = index < _seasoningStep;
                  final active = index == _seasoningStep;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 9),
                    child: Row(
                      children: [
                        Icon(
                          completed
                              ? Icons.check_circle_rounded
                              : active
                              ? Icons.radio_button_checked_rounded
                              : Icons.radio_button_unchecked_rounded,
                          color: completed || active
                              ? item.color
                              : Colors.white24,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            item.label,
                            style: TextStyle(
                              color: active
                                  ? Colors.white
                                  : completed
                                  ? Colors.white70
                                  : Colors.white30,
                              fontSize: 16,
                              fontWeight: active
                                  ? FontWeight.w900
                                  : FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExplosion() {
    return AnimatedBuilder(
      key: const ValueKey('blast'),
      animation: _explosionController,
      builder: (context, _) {
        final progress = _explosionController.value;
        final flash = progress < 0.14 ? 1 - progress / 0.14 : 0.0;
        final textScale = 0.55 + Curves.elasticOut.transform(progress) * 0.85;
        final background = progress < 0.18
            ? Color.lerp(
                TimeBombApp.signalYellow,
                Colors.white,
                progress / 0.18,
              )!
            : Color.lerp(
                Colors.white,
                TimeBombApp.warningRed,
                ((progress - 0.18) / 0.82).clamp(0.0, 1.0),
              )!;

        return ColoredBox(
          color: background,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CustomPaint(painter: _ExplosionBlastPainter(progress)),
              Center(
                child: Transform.rotate(
                  angle:
                      math.sin(progress * math.pi * 8) * (1 - progress) * 0.08,
                  child: Transform.scale(
                    scale: textScale,
                    child: Text(
                      context.l10n.boom,
                      style: const TextStyle(
                        color: TimeBombApp.coal,
                        fontSize: 76,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ),
              ),
              if (flash > 0)
                ColoredBox(color: Colors.white.withValues(alpha: flash * 0.82)),
            ],
          ),
        );
      },
    );
  }

  Widget _buildResult() {
    return Container(
      key: const ValueKey('result'),
      width: double.infinity,
      color: TimeBombApp.warningRed,
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.45, end: 1),
                duration: const Duration(milliseconds: 560),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: const Icon(
                  Icons.local_fire_department_rounded,
                  color: TimeBombApp.signalYellow,
                  size: 92,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                context.l10n.boom,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _round.currentPlayer,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 52,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                context.l10n.takePunishment,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                context.l10n.bombResult(
                  _bombSettings.grams,
                  context.l10n.flavorLabel(_bombSettings),
                ),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: TimeBombApp.signalYellow,
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _punishmentStatus ?? context.l10n.triggeringDevice,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 48),
              FilledButton.icon(
                onPressed: _restart,
                style: FilledButton.styleFrom(
                  backgroundColor: TimeBombApp.coal,
                  foregroundColor: Colors.white,
                ),
                icon: const Icon(Icons.replay_rounded),
                label: Text(context.l10n.playAgain),
              ),
              const SizedBox(height: 10),
              OutlinedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(54),
                  foregroundColor: Colors.white,
                  side: const BorderSide(color: Colors.white, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(Icons.tune_rounded),
                label: Text(context.l10n.resetGame),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmExit() async {
    final shouldExit = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(context.l10n.exitRoundTitle),
        content: Text(context.l10n.exitRoundBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(context.l10n.continueGame),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(context.l10n.exit),
          ),
        ],
      ),
    );
    if (shouldExit == true && mounted) Navigator.of(context).pop();
  }
}

class _SeasoningItem {
  const _SeasoningItem({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;
}

class _ExplosionBlastPainter extends CustomPainter {
  const _ExplosionBlastPainter(this.progress);

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final shortestSide = size.shortestSide;
    final burst = Curves.easeOutExpo.transform(progress);
    final fade = (1 - progress).clamp(0.0, 1.0);

    // 多层冲击波、放射线和碎片同时扩散，形成完整的爆点反馈。
    for (var ring = 0; ring < 3; ring++) {
      final delayed = ((burst - ring * 0.12) / (1 - ring * 0.12)).clamp(
        0.0,
        1.0,
      );
      if (delayed <= 0) continue;
      canvas.drawCircle(
        center,
        shortestSide * (0.08 + delayed * 0.68),
        Paint()
          ..color = (ring.isEven ? Colors.white : TimeBombApp.signalYellow)
              .withValues(alpha: (1 - delayed) * 0.75)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18 - ring * 4,
      );
    }

    for (var index = 0; index < 24; index++) {
      final angle = math.pi * 2 * index / 24;
      final stagger = 0.72 + (index % 4) * 0.08;
      final startRadius = shortestSide * (0.08 + burst * 0.18);
      final endRadius = shortestSide * burst * stagger;
      final start = center.translate(
        math.cos(angle) * startRadius,
        math.sin(angle) * startRadius,
      );
      final end = center.translate(
        math.cos(angle) * endRadius,
        math.sin(angle) * endRadius,
      );
      final color = switch (index % 3) {
        0 => Colors.white,
        1 => TimeBombApp.signalYellow,
        _ => TimeBombApp.coal,
      };
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = color.withValues(alpha: fade * 0.9)
          ..strokeWidth = index.isEven ? 7 : 4
          ..strokeCap = StrokeCap.round,
      );
      canvas.drawCircle(
        end,
        index.isEven ? 6 : 4,
        Paint()..color = color.withValues(alpha: fade),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _ExplosionBlastPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _GramKeypad extends StatelessWidget {
  const _GramKeypad({
    required this.value,
    required this.label,
    required this.unit,
    required this.onDigit,
    required this.onClear,
    required this.onBackspace,
  });

  final String value;
  final String label;
  final String unit;
  final ValueChanged<int> onDigit;
  final VoidCallback onClear;
  final VoidCallback onBackspace;

  @override
  Widget build(BuildContext context) {
    final displayValue = value.isEmpty ? '0' : value;
    final rows = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: TimeBombApp.coal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Semantics(
            liveRegion: true,
            label: '$label $displayValue $unit',
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    displayValue,
                    key: const ValueKey('pending-grams'),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    style: TextStyle(
                      color: value.isEmpty
                          ? Colors.white38
                          : TimeBombApp.signalYellow,
                      fontSize: 44,
                      height: 1,
                      fontWeight: FontWeight.w900,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text(
                    unit,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          for (final row in rows) ...[
            _KeypadRow(
              children: [
                for (final digit in row)
                  _KeypadButton(
                    key: ValueKey('gram-key-$digit'),
                    onPressed: () => onDigit(digit),
                    child: Text('$digit'),
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
          _KeypadRow(
            children: [
              _KeypadButton(
                key: const ValueKey('gram-clear'),
                onPressed: onClear,
                backgroundColor: Colors.white12,
                foregroundColor: Colors.white,
                child: const Text('C'),
              ),
              _KeypadButton(
                key: const ValueKey('gram-key-0'),
                onPressed: () => onDigit(0),
                child: const Text('0'),
              ),
              _KeypadButton(
                key: const ValueKey('gram-backspace'),
                onPressed: onBackspace,
                backgroundColor: TimeBombApp.warningRed,
                foregroundColor: Colors.white,
                child: Tooltip(
                  message: MaterialLocalizations.of(
                    context,
                  ).deleteButtonTooltip,
                  child: const Icon(Icons.backspace_outlined),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _KeypadRow extends StatelessWidget {
  const _KeypadRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var index = 0; index < children.length; index++) ...[
          Expanded(child: children[index]),
          if (index < children.length - 1) const SizedBox(width: 8),
        ],
      ],
    );
  }
}

class _KeypadButton extends StatelessWidget {
  const _KeypadButton({
    required this.onPressed,
    required this.child,
    this.backgroundColor = Colors.white,
    this.foregroundColor = TimeBombApp.coal,
    super.key,
  });

  final VoidCallback onPressed;
  final Widget child;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(6),
        child: SizedBox(
          height: 50,
          child: Center(
            child: DefaultTextStyle.merge(
              style: TextStyle(
                color: foregroundColor,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
              child: IconTheme(
                data: IconThemeData(color: foregroundColor, size: 22),
                child: child,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _SeasoningToggle extends StatelessWidget {
  const _SeasoningToggle({
    required this.label,
    required this.icon,
    required this.selected,
    required this.enabled,
    required this.onChanged,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final bool enabled;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? TimeBombApp.warningRed
          : enabled
          ? Colors.white
          : Colors.white54,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: selected ? TimeBombApp.warningRed : TimeBombApp.coal,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: enabled ? () => onChanged(!selected) : null,
        borderRadius: BorderRadius.circular(8),
        child: SizedBox(
          height: 54,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected
                    ? Colors.white
                    : enabled
                    ? TimeBombApp.coal
                    : Colors.black38,
              ),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : enabled
                        ? TimeBombApp.coal
                        : Colors.black38,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              IgnorePointer(
                child: SizedBox(
                  width: 34,
                  child: Checkbox(
                    value: selected,
                    onChanged: (_) {},
                    activeColor: TimeBombApp.coal,
                    checkColor: Colors.white,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: BorderSide(
                      color: selected ? Colors.white : TimeBombApp.coal,
                      width: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DangerVeilPainter extends CustomPainter {
  const _DangerVeilPainter({required this.animation});

  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    // 最后五秒用一层很轻的红色闪烁覆盖全屏，提醒玩家已经进入临界段。
    final flash = math.pow(animation, 2.2).toDouble();
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..color = TimeBombApp.warningRed.withValues(
          alpha: 0.035 + flash * 0.11,
        ),
    );
  }

  @override
  bool shouldRepaint(covariant _DangerVeilPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}

class _BombPainter extends CustomPainter {
  const _BombPainter({
    required this.urgent,
    required this.critical,
    required this.animation,
  });

  final bool urgent;
  final bool critical;
  final double animation;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide * 0.39;

    final bombRadius = radius * 0.67;
    if (urgent) {
      // 脉冲光圈会随危险等级放大，最后五秒额外增加一圈。
      final ringCount = critical ? 3 : 1;
      for (var index = 0; index < ringCount; index++) {
        final ringProgress = (animation + index * 0.34) % 1;
        final ringRadius = bombRadius * (1.06 + ringProgress * 0.42);
        canvas.drawCircle(
          center,
          ringRadius,
          Paint()
            ..color = TimeBombApp.signalYellow.withValues(
              alpha: (critical ? 0.24 : 0.14) * (1 - ringProgress),
            )
            ..style = PaintingStyle.stroke
            ..strokeWidth = critical ? 5 : 3,
        );
      }
    }
    canvas.drawCircle(
      center,
      bombRadius,
      Paint()
        ..color = Color.lerp(
          const Color(0xFF2C2C2C),
          TimeBombApp.warningRed,
          critical
              ? animation * 0.28
              : urgent
              ? animation * 0.1
              : 0,
        )!,
    );
    canvas.drawCircle(
      center.translate(-bombRadius * 0.26, -bombRadius * 0.28),
      bombRadius * 0.12,
      Paint()..color = Colors.white.withValues(alpha: 0.08),
    );

    final fuseStart = center.translate(bombRadius * 0.45, -bombRadius * 0.78);
    final fusePath = Path()
      ..moveTo(fuseStart.dx, fuseStart.dy)
      ..quadraticBezierTo(
        center.dx + radius * 0.55,
        center.dy - radius * 0.95,
        center.dx + radius * 0.7,
        center.dy - radius * 0.72,
      );
    canvas.drawPath(
      fusePath,
      Paint()
        ..color = const Color(0xFFB5AEA0)
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round
        ..strokeWidth = 7,
    );
    final spark = center.translate(radius * 0.71, -radius * 0.71);
    final sparkRadius = urgent
        ? 8 + animation * (critical ? 11 : 7)
        : 6 + animation * 2;
    canvas.drawCircle(
      spark,
      sparkRadius,
      Paint()..color = TimeBombApp.signalYellow,
    );
    for (var index = 0; index < 8; index++) {
      final angle = math.pi * 2 * index / 8 + animation * 0.35;
      final start = spark.translate(
        math.cos(angle) * (sparkRadius + 3),
        math.sin(angle) * (sparkRadius + 3),
      );
      final end = spark.translate(
        math.cos(angle) * (sparkRadius + 8 + animation * (critical ? 11 : 7)),
        math.sin(angle) * (sparkRadius + 8 + animation * (critical ? 11 : 7)),
      );
      canvas.drawLine(
        start,
        end,
        Paint()
          ..color = TimeBombApp.signalYellow.withValues(
            alpha: 0.45 + animation * 0.5,
          )
          ..strokeCap = StrokeCap.round
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _BombPainter oldDelegate) {
    return oldDelegate.urgent != urgent ||
        oldDelegate.critical != critical ||
        oldDelegate.animation != animation;
  }
}
