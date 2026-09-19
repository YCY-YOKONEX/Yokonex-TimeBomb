import 'package:flutter_test/flutter_test.dart';
import 'package:yokonex_time_bomb/ems/ems_protocol.dart';

void main() {
  group('EmsProtocol', () {
    test('炸弹克数按 180 对应设备 276 换算', () {
      expect(EmsProtocol.toDeviceIntensity(0), 0);
      expect(EmsProtocol.toDeviceIntensity(90), 138);
      expect(EmsProtocol.toDeviceIntensity(180), 276);
    });

    test('一代使用自定义模式输出指定的 B 通道', () {
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.first,
          channel: EmsChannel.b,
          displayIntensity: 180,
          frequency: 100,
          pulseWidth: 100,
        ),
        [0x35, 0x11, 0x02, 0x01, 0x01, 0x14, 0x11, 0x64, 0x64, 0x37],
      );
    });

    test('二代使用实时模式只输出指定的 A 通道', () {
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.second,
          channel: EmsChannel.a,
          displayIntensity: 180,
          frequency: 100,
          pulseWidth: 100,
        ),
        [
          0x35,
          0x11,
          0x02,
          0x01,
          0x14,
          0x64,
          0x64,
          0x00,
          0x00,
          0x00,
          0x00,
          0x25,
        ],
      );
    });

    test('二代使用实时模式只输出指定的 B 通道', () {
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.second,
          channel: EmsChannel.b,
          displayIntensity: 180,
          frequency: 100,
          pulseWidth: 100,
        ),
        [
          0x35,
          0x11,
          0x02,
          0x00,
          0x00,
          0x00,
          0x00,
          0x01,
          0x14,
          0x64,
          0x64,
          0x25,
        ],
      );
    });

    test('实时模式会限制频率和脉宽范围', () {
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.first,
          channel: EmsChannel.a,
          displayIntensity: 90,
          frequency: 200,
          pulseWidth: 200,
        ),
        [0x35, 0x11, 0x01, 0x01, 0x00, 0x8a, 0x11, 0x64, 0x64, 0xab],
      );
    });

    test('关闭命令使用实时模式并将全部输出归零', () {
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.first,
          displayIntensity: 0,
          frequency: 0,
          pulseWidth: 0,
        ),
        [0x35, 0x11, 0x03, 0x00, 0x00, 0x00, 0x11, 0x00, 0x00, 0x5a],
      );
      expect(
        EmsProtocol.buildRealtimeModePacket(
          generation: EmsGeneration.second,
          displayIntensity: 0,
          frequency: 0,
          pulseWidth: 0,
        ),
        [
          0x35,
          0x11,
          0x02,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x00,
          0x48,
        ],
      );
    });

    test('爆炸冲击波按 100ms 一帧并持续衰减', () {
      final frames = EmsProtocol.explosionShockwave;
      expect(frames, hasLength(8));
      expect(
        frames.every((frame) => frame.duration.inMilliseconds == 100),
        isTrue,
      );
      for (var index = 1; index < frames.length; index++) {
        expect(frames[index].amplitude, lessThan(frames[index - 1].amplitude));
      }
    });
  });
}
