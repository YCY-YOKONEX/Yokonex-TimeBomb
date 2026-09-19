import 'package:flutter_test/flutter_test.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:yokonex_time_bomb/ems/ems_controller.dart';
import 'package:yokonex_time_bomb/ems/ems_protocol.dart';

void main() {
  test('根据设备名称自动识别一代和二代协议', () {
    final first = EmsDeviceRecord(
      BleDevice(deviceId: 'device-1', name: 'YYC-DJ'),
    );
    final second = EmsDeviceRecord(
      BleDevice(deviceId: 'device-2', name: 'YYC-DJ-V2'),
    );

    expect(first.generation, EmsGeneration.first);
    expect(second.generation, EmsGeneration.second);
  });

  test('多台设备使用连接顺序编号展示', () {
    final first = EmsDeviceRecord(
      BleDevice(deviceId: 'device-1', name: 'YYC-DJ'),
    )..connectionDisplayIndex = 1;
    final second = EmsDeviceRecord(
      BleDevice(deviceId: 'device-2', name: 'YYC-DJ-V2'),
    )..connectionDisplayIndex = 2;

    expect(first.displayName, 'YYC-DJ 1');
    expect(second.displayName, 'YYC-DJ-V2 2');
  });

  test('已占用通道不能再次绑定其他玩家', () {
    final record = EmsDeviceRecord(
      BleDevice(deviceId: 'device-1', name: 'YYC-DJ'),
    );

    EmsController.instance.assignChannel(record, EmsChannel.a, 0);
    EmsController.instance.assignChannel(record, EmsChannel.a, 1);

    expect(record.playerFor(EmsChannel.a), 0);
  });

  test('修改玩家通道后测试和人工确认状态失效', () {
    final record = EmsDeviceRecord(
      BleDevice(deviceId: 'device-1', name: 'EMS-01'),
    );

    record.setPlayer(EmsChannel.a, 0);
    record.setTested(EmsChannel.a, true);
    record.setConfirmed(EmsChannel.a, true);

    record.setPlayer(EmsChannel.a, 1);

    expect(record.playerFor(EmsChannel.a), 1);
    expect(record.testedFor(EmsChannel.a), isFalse);
    expect(record.confirmedFor(EmsChannel.a), isFalse);
  });
}
