import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:universal_ble/universal_ble.dart';

import 'ems_protocol.dart';

enum EmsDeviceErrorKind {
  connection,
  waveformTest,
  trigger,
  stop,
  emergencyStop,
}

class EmsDeviceRecord {
  EmsDeviceRecord(this.device);

  BleDevice device;
  int? connectionSequence;
  int? connectionDisplayIndex;
  int? playerAIndex;
  int? playerBIndex;
  bool channelATested = false;
  bool channelBTested = false;
  bool channelAConfirmed = false;
  bool channelBConfirmed = false;
  BleConnectionState connectionState = BleConnectionState.disconnected;
  EmsDeviceErrorKind? errorKind;
  String? errorDetail;
  List<int> lastNotification = const [];

  String get id => device.deviceId;
  String get name {
    final deviceName = device.name?.trim();
    return deviceName == null || deviceName.isEmpty
        ? device.deviceId
        : deviceName;
  }

  String get displayName =>
      connectionDisplayIndex == null ? name : '$name $connectionDisplayIndex';

  // 蓝牙名称由硬件固件固定提供，直接据此选择对应通信协议。
  EmsGeneration get generation => switch (name.toUpperCase()) {
    'YYC-DJ' => EmsGeneration.first,
    'YYC-DJ-V2' => EmsGeneration.second,
    _ => EmsGeneration.second,
  };

  bool get isConnected => connectionState == BleConnectionState.connected;
  bool get isConnecting => connectionState == BleConnectionState.connecting;

  int? playerFor(EmsChannel channel) {
    return channel == EmsChannel.a ? playerAIndex : playerBIndex;
  }

  bool testedFor(EmsChannel channel) {
    return channel == EmsChannel.a ? channelATested : channelBTested;
  }

  bool confirmedFor(EmsChannel channel) {
    return channel == EmsChannel.a ? channelAConfirmed : channelBConfirmed;
  }

  void setPlayer(EmsChannel channel, int? playerIndex) {
    if (channel == EmsChannel.a) {
      playerAIndex = playerIndex;
      channelATested = false;
      channelAConfirmed = false;
    } else {
      playerBIndex = playerIndex;
      channelBTested = false;
      channelBConfirmed = false;
    }
  }

  void setTested(EmsChannel channel, bool tested) {
    if (channel == EmsChannel.a) {
      channelATested = tested;
      if (!tested) channelAConfirmed = false;
    } else {
      channelBTested = tested;
      if (!tested) channelBConfirmed = false;
    }
  }

  void setConfirmed(EmsChannel channel, bool confirmed) {
    if (channel == EmsChannel.a) {
      channelAConfirmed = confirmed;
    } else {
      channelBConfirmed = confirmed;
    }
  }
}

class EmsChannelSlot {
  const EmsChannelSlot(this.device, this.channel);

  final EmsDeviceRecord device;
  final EmsChannel channel;

  String get key => '${device.id}:${channel.name}';
  int? get playerIndex => device.playerFor(channel);
  bool get tested => device.testedFor(channel);
  bool get confirmed => device.confirmedFor(channel);
}

class EmsTriggerReport {
  const EmsTriggerReport({required this.attempted, required this.succeeded});

  final int attempted;
  final int succeeded;
}

class EmsController extends ChangeNotifier {
  EmsController._() {
    // 每台设备使用独立命令队列，保证多设备可并发触发。
    UniversalBle.queueType = QueueType.perDevice;
  }

  static final instance = EmsController._();

  static const serviceUuid = '0000ff30-0000-1000-8000-00805f9b34fb';
  static const writeUuid = '0000ff31-0000-1000-8000-00805f9b34fb';
  static const notifyUuid = '0000ff32-0000-1000-8000-00805f9b34fb';

  final Map<String, EmsDeviceRecord> _devices = {};
  final Map<String, StreamSubscription<bool>> _connectionSubscriptions = {};
  final Map<String, StreamSubscription<List<int>>> _notificationSubscriptions =
      {};
  final Map<String, BleCharacteristic> _writeCharacteristics = {};
  final Map<String, BleCharacteristic> _notifyCharacteristics = {};
  final Set<String> _testingChannels = {};
  int _nextConnectionSequence = 0;

  StreamSubscription<BleDevice>? _scanSubscription;
  Timer? _scanTimer;
  bool isScanning = false;

  List<EmsDeviceRecord> get devices {
    final values = _devices.values.toList();
    values.sort((a, b) {
      if (a.isConnected != b.isConnected) return a.isConnected ? -1 : 1;
      if (a.isConnected && b.isConnected) {
        return (a.connectionSequence ?? 0).compareTo(b.connectionSequence ?? 0);
      }
      return a.name.compareTo(b.name);
    });
    return values;
  }

  int get connectedCount =>
      _devices.values.where((device) => device.isConnected).length;

  int assignedPlayerCount(int playerCount) {
    return List.generate(
      playerCount,
      (index) => index,
    ).where((index) => _targetForPlayer(index) != null).length;
  }

  int testedPlayerCount(int playerCount) {
    return List.generate(playerCount, (index) => index).where((index) {
      final target = _targetForPlayer(index);
      return target != null && target.device.testedFor(target.channel);
    }).length;
  }

  int confirmedPlayerCount(int playerCount) {
    return List.generate(playerCount, (index) => index).where((index) {
      final target = _targetForPlayer(index);
      return target != null && target.device.confirmedFor(target.channel);
    }).length;
  }

  bool hasCompleteAssignments(int playerCount) {
    return playerCount > 0 && assignedPlayerCount(playerCount) == playerCount;
  }

  bool areAssignmentsTested(int playerCount) {
    return hasCompleteAssignments(playerCount) &&
        testedPlayerCount(playerCount) == playerCount;
  }

  bool areAssignmentsConfirmed(int playerCount) {
    return areAssignmentsTested(playerCount) &&
        confirmedPlayerCount(playerCount) == playerCount;
  }

  List<EmsChannelSlot> get connectedChannelSlots {
    return [
      for (final device in devices)
        if (device.isConnected)
          for (final channel in EmsChannel.values)
            EmsChannelSlot(device, channel),
    ];
  }

  List<EmsChannelSlot> availableChannelSlotsForPlayer(int playerIndex) {
    return connectedChannelSlots.where((slot) {
      return slot.playerIndex == null || slot.playerIndex == playerIndex;
    }).toList();
  }

  EmsChannelSlot? assignmentForPlayer(int playerIndex) {
    return _targetForPlayer(playerIndex);
  }

  bool isTesting(EmsDeviceRecord device, EmsChannel channel) {
    return _testingChannels.contains(_channelKey(device, channel));
  }

  Future<void> startScan() async {
    if (isScanning) return;
    try {
      await UniversalBle.requestPermissions();
      final availability = await UniversalBle.getBluetoothAvailabilityState();
      if (availability != AvailabilityState.poweredOn) {
        notifyListeners();
        return;
      }

      await stopScan();
      isScanning = true;
      notifyListeners();

      _scanSubscription = UniversalBle.scanStream.listen(
        (device) {
          final record = _devices.putIfAbsent(
            device.deviceId,
            () => EmsDeviceRecord(device),
          );
          record.device = device;
          notifyListeners();
        },
        onError: (Object error) {
          isScanning = false;
          notifyListeners();
        },
      );
      await UniversalBle.startScan(
        scanFilter: ScanFilter(withServices: [serviceUuid]),
      );
      _scanTimer = Timer(const Duration(seconds: 10), stopScan);
    } catch (error) {
      isScanning = false;
      notifyListeners();
    }
  }

  Future<void> stopScan() async {
    _scanTimer?.cancel();
    _scanTimer = null;
    await _scanSubscription?.cancel();
    _scanSubscription = null;
    if (isScanning) {
      try {
        await UniversalBle.stopScan();
      } catch (_) {
        // 蓝牙关闭时停止扫描可能失败，此时只需要恢复界面状态。
      }
      isScanning = false;
      notifyListeners();
    }
  }

  Future<void> connect(EmsDeviceRecord record) async {
    if (record.isConnected || record.isConnecting) return;
    await stopScan();
    record.errorKind = null;
    record.errorDetail = null;
    record.connectionState = BleConnectionState.connecting;
    notifyListeners();

    await _connectionSubscriptions[record.id]?.cancel();
    _connectionSubscriptions[record.id] = record.device.connectionStream.listen(
      (connected) {
        _updateConnectionState(record, connected);
        if (!connected) {
          record.channelATested = false;
          record.channelBTested = false;
          record.channelAConfirmed = false;
          record.channelBConfirmed = false;
        }
        notifyListeners();
      },
    );

    try {
      await record.device.connect(
        timeout: const Duration(seconds: 12),
        platformConfig: ConnectionPlatformConfig(
          android: AndroidConnectionOptions(closeGattOnDetach: true),
        ),
      );
      _updateConnectionState(record, true);
      await _prepareCharacteristics(record);
      record.errorKind = null;
      record.errorDetail = null;
    } catch (error) {
      _updateConnectionState(record, false);
      record.errorKind = EmsDeviceErrorKind.connection;
      record.errorDetail = '$error';
    }
    notifyListeners();
  }

  Future<void> disconnect(EmsDeviceRecord record) async {
    try {
      await _stopOutput(record);
    } catch (_) {
      // 断开前尽力关闭输出，设备已离线时继续执行断开清理。
    }
    await _notificationSubscriptions.remove(record.id)?.cancel();
    final notifyCharacteristic = _notifyCharacteristics.remove(record.id);
    if (notifyCharacteristic != null && notifyCharacteristic.isSubscribed) {
      await notifyCharacteristic.unsubscribe();
    }
    _writeCharacteristics.remove(record.id);
    await record.device.disconnect(timeout: const Duration(seconds: 8));
    await _connectionSubscriptions.remove(record.id)?.cancel();
    _updateConnectionState(record, false);
    record.channelATested = false;
    record.channelBTested = false;
    record.channelAConfirmed = false;
    record.channelBConfirmed = false;
    notifyListeners();
  }

  void assignChannel(
    EmsDeviceRecord record,
    EmsChannel channel,
    int? playerIndex,
  ) {
    if (playerIndex != null) {
      final occupiedPlayer = record.playerFor(channel);
      if (occupiedPlayer != null && occupiedPlayer != playerIndex) return;

      // 一个玩家只能占用一个通道，重新选择时自动释放旧通道。
      for (final device in _devices.values) {
        for (final candidate in EmsChannel.values) {
          if (device.playerFor(candidate) == playerIndex) {
            device.setPlayer(candidate, null);
          }
        }
      }
    }
    record.setPlayer(channel, playerIndex);
    notifyListeners();
  }

  void assignPlayerToChannel(int playerIndex, String? channelKey) {
    final current = _assignedTargetForPlayer(playerIndex);
    if (channelKey == null) {
      current?.device.setPlayer(current.channel, null);
      notifyListeners();
      return;
    }

    final target = connectedChannelSlots
        .where((slot) => slot.key == channelKey)
        .firstOrNull;
    if (target == null || target.key == current?.key) return;
    if (target.playerIndex != null && target.playerIndex != playerIndex) return;

    // 已绑定通道不会再次分配，只允许玩家切换到空闲通道。
    current?.device.setPlayer(current.channel, null);
    target.device.setPlayer(target.channel, playerIndex);
    notifyListeners();
  }

  int autoAssignChannels(int playerCount) {
    final slots = connectedChannelSlots;
    for (final device in _devices.values) {
      for (final channel in EmsChannel.values) {
        if (device.playerFor(channel) != null) {
          device.setPlayer(channel, null);
        }
      }
    }

    final assigned = playerCount.clamp(0, slots.length);
    for (var index = 0; index < assigned; index++) {
      slots[index].device.setPlayer(slots[index].channel, index);
    }
    notifyListeners();
    return assigned;
  }

  Future<int> testAllAssignedChannels(int playerCount) async {
    var succeeded = 0;
    // 按玩家顺序逐个测试，便于现场确认电极和通道对应关系。
    for (var playerIndex = 0; playerIndex < playerCount; playerIndex++) {
      final target = _targetForPlayer(playerIndex);
      if (target != null && await testChannel(target.device, target.channel)) {
        succeeded++;
      }
    }
    return succeeded;
  }

  bool confirmPlayerAssignment(int playerIndex) {
    final target = _targetForPlayer(playerIndex);
    if (target == null || !target.device.testedFor(target.channel)) {
      return false;
    }
    target.device.setConfirmed(target.channel, true);
    notifyListeners();
    return true;
  }

  void normalizeAssignments(int playerCount) {
    var changed = false;
    for (final device in _devices.values) {
      for (final channel in EmsChannel.values) {
        final playerIndex = device.playerFor(channel);
        if (playerIndex != null && playerIndex >= playerCount) {
          device.setPlayer(channel, null);
          changed = true;
        }
      }
    }
    if (changed) notifyListeners();
  }

  void removePlayerAt(int removedIndex) {
    for (final device in _devices.values) {
      for (final channel in EmsChannel.values) {
        final playerIndex = device.playerFor(channel);
        if (playerIndex == removedIndex) {
          device.setPlayer(channel, null);
        } else if (playerIndex != null && playerIndex > removedIndex) {
          if (channel == EmsChannel.a) {
            device.playerAIndex = playerIndex - 1;
          } else {
            device.playerBIndex = playerIndex - 1;
          }
        }
      }
    }
    notifyListeners();
  }

  Future<bool> testChannel(EmsDeviceRecord device, EmsChannel channel) async {
    if (!device.isConnected || device.playerFor(channel) == null) return false;
    final key = _channelKey(device, channel);
    if (!_testingChannels.add(key)) return false;
    device.setTested(channel, false);
    device.errorKind = null;
    device.errorDetail = null;
    notifyListeners();

    var succeeded = false;
    try {
      // 测试使用最低克数和基础频率，只验证玩家与通道是否对应。
      await _playExplosionShockwave(device, channel, 5, peakFrequency: 50);
      device.setTested(channel, true);
      succeeded = true;
    } catch (error) {
      device.errorKind = EmsDeviceErrorKind.waveformTest;
      device.errorDetail = '$error';
    } finally {
      try {
        await _stopOutput(device, channel: channel);
      } catch (_) {
        // 测试结束始终尽力关闭当前通道。
      }
      _testingChannels.remove(key);
      notifyListeners();
    }
    return succeeded;
  }

  Future<EmsTriggerReport> triggerForPlayer({
    required int playerIndex,
    required int bombGrams,
    required int frequency,
  }) async {
    final target = _targetForPlayer(playerIndex);
    if (target == null) {
      return const EmsTriggerReport(attempted: 0, succeeded: 0);
    }

    var succeeded = 0;
    try {
      await _playExplosionShockwave(
        target.device,
        target.channel,
        bombGrams,
        peakFrequency: frequency,
      );
      succeeded = 1;
    } catch (error) {
      target.device.errorKind = EmsDeviceErrorKind.trigger;
      target.device.errorDetail = '$error';
    } finally {
      try {
        await _stopOutput(target.device, channel: target.channel);
      } catch (error) {
        target.device.errorKind = EmsDeviceErrorKind.stop;
        target.device.errorDetail = '$error';
      }
    }
    notifyListeners();
    return EmsTriggerReport(attempted: 1, succeeded: succeeded);
  }

  Future<void> stopAll() async {
    final targets = _devices.values.where((device) => device.isConnected);
    await Future.wait(
      targets.map((device) async {
        try {
          await _stopOutput(device);
        } catch (error) {
          device.errorKind = EmsDeviceErrorKind.emergencyStop;
          device.errorDetail = '$error';
        }
      }),
    );
    notifyListeners();
  }

  Future<void> _prepareCharacteristics(EmsDeviceRecord record) async {
    await record.device.discoverServices(timeout: const Duration(seconds: 10));
    final writeCharacteristic = await record.device.getCharacteristic(
      writeUuid,
      service: serviceUuid,
    );
    final notifyCharacteristic = await record.device.getCharacteristic(
      notifyUuid,
      service: serviceUuid,
    );
    _writeCharacteristics[record.id] = writeCharacteristic;
    _notifyCharacteristics[record.id] = notifyCharacteristic;

    await _notificationSubscriptions[record.id]?.cancel();
    _notificationSubscriptions[record.id] = notifyCharacteristic.onValueReceived
        .listen((data) {
          record.lastNotification = data;
          notifyListeners();
        });
    await notifyCharacteristic.notifications.subscribe();
  }

  Future<void> _playExplosionShockwave(
    EmsDeviceRecord device,
    EmsChannel channel,
    int bombGrams, {
    int peakFrequency = 100,
  }) async {
    for (final frame in EmsProtocol.explosionShockwave) {
      final frameIntensity = (bombGrams * frame.amplitude).round().clamp(
        1,
        EmsProtocol.maxDisplayIntensity,
      );
      final frameFrequency = (peakFrequency * frame.frequency / 100)
          .round()
          .clamp(1, 100);
      await _writeRealtimeFrame(
        device,
        channel,
        frameIntensity,
        frequency: frameFrequency,
        pulseWidth: frame.pulseWidth,
      );
      await Future<void>.delayed(frame.duration);
    }
  }

  Future<void> _stopOutput(
    EmsDeviceRecord device, {
    EmsChannel? channel,
  }) async {
    await _writeRealtimeFrame(device, channel, 0, frequency: 0, pulseWidth: 0);
  }

  Future<void> _writeRealtimeFrame(
    EmsDeviceRecord device,
    EmsChannel? channel,
    int displayIntensity, {
    required int frequency,
    required int pulseWidth,
  }) async {
    final characteristic = _writeCharacteristics[device.id];
    if (characteristic == null) {
      throw StateError('Device characteristic unavailable');
    }
    final packet = EmsProtocol.buildRealtimeModePacket(
      generation: device.generation,
      channel: channel,
      displayIntensity: displayIntensity,
      frequency: frequency,
      pulseWidth: pulseWidth,
    );
    await characteristic.write(packet, withResponse: false);
  }

  EmsChannelSlot? _assignedTargetForPlayer(int playerIndex) {
    for (final device in _devices.values) {
      for (final channel in EmsChannel.values) {
        if (device.playerFor(channel) == playerIndex) {
          return EmsChannelSlot(device, channel);
        }
      }
    }
    return null;
  }

  EmsChannelSlot? _targetForPlayer(int playerIndex) {
    final target = _assignedTargetForPlayer(playerIndex);
    return target != null && target.device.isConnected ? target : null;
  }

  String _channelKey(EmsDeviceRecord device, EmsChannel channel) {
    return '${device.id}:${channel.name}';
  }

  void _updateConnectionState(EmsDeviceRecord record, bool connected) {
    if (connected) {
      if (!record.isConnected || record.connectionSequence == null) {
        record.connectionSequence = ++_nextConnectionSequence;
      }
      record.connectionState = BleConnectionState.connected;
    } else {
      record.connectionState = BleConnectionState.disconnected;
      record.connectionSequence = null;
    }
    _refreshConnectionDisplayIndexes();
  }

  void _refreshConnectionDisplayIndexes() {
    final connected =
        _devices.values.where((device) => device.isConnected).toList()..sort(
          (a, b) =>
              (a.connectionSequence ?? 0).compareTo(b.connectionSequence ?? 0),
        );

    for (final device in _devices.values) {
      device.connectionDisplayIndex = null;
    }
    if (connected.length <= 1) return;

    // 多台设备统一按本次连接先后编号，避免相同蓝牙名称无法区分。
    for (var index = 0; index < connected.length; index++) {
      connected[index].connectionDisplayIndex = index + 1;
    }
  }
}
