import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ems/ems_controller.dart';
import '../l10n/l10n.dart';
import '../main.dart';
import '../widgets/time_bomb_logo.dart';
import 'device_page.dart';
import 'game_page.dart';

class SetupPage extends StatefulWidget {
  const SetupPage({this.selectedLocale, this.onLocaleChanged, super.key});

  final Locale? selectedLocale;
  final ValueChanged<Locale?>? onLocaleChanged;

  @override
  State<SetupPage> createState() => _SetupPageState();
}

class _SetupPageState extends State<SetupPage> {
  final EmsController _deviceController = EmsController.instance;
  final List<TextEditingController> _players = [];
  final List<String> _defaultPlayerNames = [];
  final TextEditingController _durationController = TextEditingController(
    text: '60',
  );

  bool _preparingChannels = false;
  bool _playersInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_playersInitialized) {
      _playersInitialized = true;
      for (var index = 1; index <= 2; index++) {
        final defaultName = context.l10n.playerDefault(index);
        _players.add(TextEditingController(text: defaultName));
        _defaultPlayerNames.add(defaultName);
      }
      _deviceController.normalizeAssignments(_players.length);
      return;
    }

    // 切换语言时只更新默认玩家名，保留用户已经输入的名字。
    for (var index = 0; index < _players.length; index++) {
      final newDefaultName = context.l10n.playerDefault(index + 1);
      if (_players[index].text == _defaultPlayerNames[index]) {
        _players[index].text = newDefaultName;
      }
      _defaultPlayerNames[index] = newDefaultName;
    }
  }

  @override
  void dispose() {
    for (final controller in _players) {
      controller.dispose();
    }
    _durationController.dispose();
    super.dispose();
  }

  void _addPlayer() {
    if (_players.length >= 8) return;
    setState(() {
      final defaultName = context.l10n.playerDefault(_players.length + 1);
      _players.add(TextEditingController(text: defaultName));
      _defaultPlayerNames.add(defaultName);
    });
    _playSound(SystemSoundType.click);
  }

  void _removePlayer(int index) {
    if (_players.length <= 2) return;
    _deviceController.removePlayerAt(index);
    setState(() {
      _players.removeAt(index).dispose();
      _defaultPlayerNames.removeAt(index);
    });
    _playSound(SystemSoundType.click);
  }

  Future<void> _openDevices() async {
    FocusManager.instance.primaryFocus?.unfocus();
    await Navigator.of(
      context,
    ).push(MaterialPageRoute<void>(builder: (_) => const DevicePage()));
  }

  Future<void> _autoAssignAndTest() async {
    final channelCount = _deviceController.connectedChannelSlots.length;
    if (channelCount < _players.length) {
      _showMessage(context.l10n.availableChannelsInsufficient(channelCount));
      return;
    }

    setState(() => _preparingChannels = true);
    _playSound(SystemSoundType.click);
    // 自动分配只生成建议并执行测试，最终对应关系仍由用户逐项确认。
    _deviceController.autoAssignChannels(_players.length);
    final succeeded = await _deviceController.testAllAssignedChannels(
      _players.length,
    );
    if (!mounted) return;
    setState(() => _preparingChannels = false);
    _playSound(
      succeeded == _players.length
          ? SystemSoundType.alert
          : SystemSoundType.click,
    );
    _showMessage(
      context.l10n.channelTestsCompleted(succeeded, _players.length),
    );
  }

  Future<void> _testPlayerChannel(int playerIndex) async {
    final target = _deviceController.assignmentForPlayer(playerIndex);
    if (target == null) return;
    _playSound(SystemSoundType.click);
    final succeeded = await _deviceController.testChannel(
      target.device,
      target.channel,
    );
    if (!mounted) return;
    _showMessage(
      succeeded
          ? context.l10n.channelTestSuccess
          : context.l10n.channelTestFailure,
    );
    _playSound(succeeded ? SystemSoundType.alert : SystemSoundType.click);
  }

  void _confirmPlayerChannel(int playerIndex) {
    if (!_deviceController.confirmPlayerAssignment(playerIndex)) {
      _playSound(SystemSoundType.click);
      _showMessage(context.l10n.completeSafetyTestFirst);
      return;
    }
    _playSound(SystemSoundType.alert);
  }

  void _startGame() {
    FocusManager.instance.primaryFocus?.unfocus();
    final names = _players.map((item) => item.text.trim()).toList();
    if (names.any((name) => name.isEmpty)) {
      _showMessage(context.l10n.playerNameRequired);
      return;
    }
    final seconds = int.tryParse(_durationController.text.trim());
    if (seconds == null || seconds <= 0) {
      _showMessage(context.l10n.durationInvalid);
      return;
    }
    if (!_deviceController.hasCompleteAssignments(names.length)) {
      _showMessage(context.l10n.assignmentRequired);
      return;
    }
    if (!_deviceController.areAssignmentsTested(names.length)) {
      _showMessage(context.l10n.assignmentTestRequired);
      return;
    }
    if (!_deviceController.areAssignmentsConfirmed(names.length)) {
      _showMessage(context.l10n.assignmentConfirmRequired);
      return;
    }

    _playSound(SystemSoundType.alert);
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => GamePage(
          players: names,
          duration: Duration(seconds: seconds),
        ),
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // 关键操作使用系统提示音，避免引入额外音频依赖并兼容桌面端。
  void _playSound(SystemSoundType type) {
    SystemSound.play(type);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _deviceController,
          builder: (context, _) {
            final playerCount = _players.length;
            final assigned = _deviceController.assignedPlayerCount(playerCount);
            final tested = _deviceController.testedPlayerCount(playerCount);
            final confirmed = _deviceController.confirmedPlayerCount(
              playerCount,
            );
            final ready = _deviceController.areAssignmentsConfirmed(
              playerCount,
            );

            final deviceSection = _SetupSection(
              number: 1,
              title: context.l10n.connectDevice,
              trailing: _deviceController.connectedCount == 0
                  ? context.l10n.notConnected
                  : context.l10n.devicesOnline(
                      _deviceController.connectedCount,
                    ),
              child: _DeviceSummary(
                controller: _deviceController,
                onManage: _openDevices,
              ),
            );
            final settingsSection = _SetupSection(
              number: 2,
              title: context.l10n.gameSettings,
              child: TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: context.l10n.duration,
                  prefixIcon: const Icon(Icons.timer_outlined),
                  suffixText: context.l10n.seconds,
                ),
              ),
            );
            final playersSection = _SetupSection(
              number: 3,
              title: context.l10n.bindPlayers,
              trailing: context.l10n.confirmedCount(confirmed, playerCount),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed:
                              !_preparingChannels &&
                                  _deviceController
                                          .connectedChannelSlots
                                          .length >=
                                      playerCount
                              ? _autoAssignAndTest
                              : null,
                          icon: _preparingChannels
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.auto_fix_high_rounded),
                          label: Text(
                            _preparingChannels
                                ? context.l10n.testingChannels
                                : context.l10n.autoAssignAndTest,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filledTonal(
                        onPressed: _players.length < 8 ? _addPlayer : null,
                        tooltip: context.l10n.addPlayer,
                        icon: const Icon(Icons.person_add_alt_1_rounded),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // 玩家绑定使用两列卡片，卡片高度按内容自适应，避免窄屏裁切按钮。
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final cardWidth = (constraints.maxWidth - 10) / 2;
                      return Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: List.generate(
                          playerCount,
                          (index) => SizedBox(
                            width: cardWidth,
                            child: _PlayerBindingRow(
                              key: ValueKey('player-binding-$index'),
                              index: index,
                              nameController: _players[index],
                              controller: _deviceController,
                              canRemove: playerCount > 2,
                              onRemove: () => _removePlayer(index),
                              onTest: () => _testPlayerChannel(index),
                              onConfirm: () => _confirmPlayerChannel(index),
                              onSound: () => _playSound(SystemSoundType.click),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );

            return LayoutBuilder(
              builder: (context, constraints) {
                final isTablet = constraints.maxWidth >= 720;
                final horizontalPadding = isTablet ? 32.0 : 18.0;
                return Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 960),
                    child: CustomScrollView(
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.fromLTRB(
                            horizontalPadding,
                            20,
                            horizontalPadding,
                            18,
                          ),
                          sliver: SliverList.list(
                            children: [
                              _SetupHeader(
                                confirmed: confirmed,
                                playerCount: playerCount,
                                selectedLocale: widget.selectedLocale,
                                onLocaleChanged: widget.onLocaleChanged,
                              ),
                              const SizedBox(height: 26),
                              if (isTablet)
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(child: deviceSection),
                                    const SizedBox(width: 28),
                                    Expanded(child: settingsSection),
                                  ],
                                )
                              else ...[
                                deviceSection,
                                settingsSection,
                              ],
                              playersSection,
                              const SizedBox(height: 8),
                              Center(
                                child: ConstrainedBox(
                                  constraints: const BoxConstraints(
                                    maxWidth: 560,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(
                                        context.l10n.bindingSummary(
                                          assigned,
                                          tested,
                                          confirmed,
                                          playerCount,
                                        ),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: ready
                                              ? const Color(0xFF237E63)
                                              : TimeBombApp.warningRed,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      FilledButton.icon(
                                        onPressed: ready ? _startGame : null,
                                        style: FilledButton.styleFrom(
                                          backgroundColor:
                                              TimeBombApp.warningRed,
                                          foregroundColor: Colors.white,
                                        ),
                                        icon: const Icon(
                                          Icons.local_fire_department_rounded,
                                        ),
                                        label: Text(context.l10n.startIgnition),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _SetupHeader extends StatelessWidget {
  const _SetupHeader({
    required this.confirmed,
    required this.playerCount,
    required this.selectedLocale,
    required this.onLocaleChanged,
  });

  final int confirmed;
  final int playerCount;
  final Locale? selectedLocale;
  final ValueChanged<Locale?>? onLocaleChanged;

  static const _languages = <(String, String)>[
    ('zh', '中文'),
    ('en', 'English'),
    ('fr', 'Français'),
    ('de', 'Deutsch'),
    ('nl', 'Nederlands'),
    ('es', 'Español'),
    ('ko', '한국어'),
    ('ja', '日本語'),
    ('it', 'Italiano'),
    ('ru', 'Русский'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 18, 16, 16),
      decoration: BoxDecoration(
        color: TimeBombApp.coal,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const TimeBombLogo(size: 48),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.appTitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
          if (onLocaleChanged != null)
            PopupMenuButton<String>(
              tooltip: context.l10n.language,
              icon: const Icon(Icons.language_rounded, color: Colors.white),
              onSelected: (code) =>
                  onLocaleChanged!(code == 'system' ? null : Locale(code)),
              itemBuilder: (context) => [
                CheckedPopupMenuItem<String>(
                  value: 'system',
                  checked: selectedLocale == null,
                  child: Text(context.l10n.systemLanguage),
                ),
                ..._languages.map(
                  (language) => CheckedPopupMenuItem<String>(
                    value: language.$1,
                    checked: selectedLocale?.languageCode == language.$1,
                    child: Text(language.$2),
                  ),
                ),
              ],
            ),
          const SizedBox(width: 4),
          Text(
            '$confirmed / $playerCount',
            style: TextStyle(
              color: confirmed == playerCount
                  ? TimeBombApp.mint
                  : TimeBombApp.signalYellow,
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _SetupSection extends StatelessWidget {
  const _SetupSection({
    required this.number,
    required this.title,
    required this.child,
    this.trailing,
  });

  final int number;
  final String title;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28,
                height: 28,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: TimeBombApp.coal,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$number',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (trailing != null)
                Text(
                  trailing!,
                  style: const TextStyle(
                    color: Color(0xFF68645C),
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          child,
          const SizedBox(height: 20),
          const Divider(height: 1),
        ],
      ),
    );
  }
}

class _DeviceSummary extends StatelessWidget {
  const _DeviceSummary({required this.controller, required this.onManage});

  final EmsController controller;
  final VoidCallback onManage;

  @override
  Widget build(BuildContext context) {
    final connected = controller.devices
        .where((device) => device.isConnected)
        .toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (connected.isEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFD7D3C9)),
            ),
            child: Row(
              children: [
                const Icon(Icons.bluetooth_searching_rounded),
                const SizedBox(width: 10),
                Expanded(child: Text(context.l10n.deviceNeeded)),
              ],
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: connected
                .map(
                  (device) => Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: TimeBombApp.mint),
                    ),
                    child: Text(
                      context.l10n.channelsAvailable(device.displayName),
                      style: const TextStyle(fontWeight: FontWeight.w800),
                    ),
                  ),
                )
                .toList(),
          ),
        const SizedBox(height: 9),
        OutlinedButton.icon(
          onPressed: onManage,
          icon: const Icon(Icons.bluetooth_rounded),
          label: Text(
            connected.isEmpty
                ? context.l10n.searchAndConnect
                : context.l10n.manageDevices,
          ),
        ),
      ],
    );
  }
}

class _PlayerBindingRow extends StatelessWidget {
  const _PlayerBindingRow({
    required this.index,
    required this.nameController,
    required this.controller,
    required this.canRemove,
    required this.onRemove,
    required this.onTest,
    required this.onConfirm,
    required this.onSound,
    super.key,
  });

  final int index;
  final TextEditingController nameController;
  final EmsController controller;
  final bool canRemove;
  final VoidCallback onRemove;
  final VoidCallback onTest;
  final VoidCallback onConfirm;
  final VoidCallback onSound;

  @override
  Widget build(BuildContext context) {
    final assignment = controller.assignmentForPlayer(index);
    final slots = controller.availableChannelSlotsForPlayer(index);
    final testing =
        assignment != null &&
        controller.isTesting(assignment.device, assignment.channel);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: assignment?.confirmed == true
              ? TimeBombApp.mint
              : const Color(0xFFD7D3C9),
          width: assignment?.confirmed == true ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: TimeBombApp.signalYellow,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: TextField(
                  controller: nameController,
                  maxLength: 12,
                  decoration: InputDecoration(
                    counterText: '',
                    hintText: context.l10n.playerHint(index + 1),
                    isDense: true,
                  ),
                ),
              ),
              IconButton(
                onPressed: canRemove ? onRemove : null,
                tooltip: context.l10n.removePlayer,
                icon: const Icon(Icons.remove_circle_outline_rounded),
              ),
            ],
          ),
          const SizedBox(height: 9),
          DropdownButtonFormField<String?>(
            key: ValueKey('channel-$index-${assignment?.key}-${slots.length}'),
            isExpanded: true,
            initialValue: assignment?.key,
            decoration: InputDecoration(
              labelText: context.l10n.deviceChannel,
              prefixIcon: const Icon(Icons.electric_bolt_rounded),
              isDense: true,
            ),
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(context.l10n.unassigned),
              ),
              ...slots.map(
                (slot) => DropdownMenuItem<String?>(
                  value: slot.key,
                  child: Text(
                    context.l10n.channelLabel(
                      slot.device.displayName,
                      slot.channel.name.toUpperCase(),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
            onChanged: (value) {
              onSound();
              controller.assignPlayerToChannel(index, value);
            },
          ),
          const SizedBox(height: 9),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: assignment != null && !testing ? onTest : null,
                  icon: testing
                      ? const SizedBox.square(
                          dimension: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          assignment?.tested == true
                              ? Icons.replay_rounded
                              : Icons.graphic_eq_rounded,
                        ),
                  label: Text(
                    testing
                        ? context.l10n.testing
                        : assignment?.tested == true
                        ? context.l10n.retest
                        : context.l10n.safetyTest,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: FilledButton.tonalIcon(
                  onPressed:
                      assignment?.tested == true &&
                          assignment?.confirmed != true
                      ? onConfirm
                      : null,
                  icon: Icon(
                    assignment?.confirmed == true
                        ? Icons.verified_rounded
                        : Icons.check_circle_outline_rounded,
                  ),
                  label: Text(
                    assignment?.confirmed == true
                        ? context.l10n.confirmed
                        : context.l10n.confirmAssignment,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
