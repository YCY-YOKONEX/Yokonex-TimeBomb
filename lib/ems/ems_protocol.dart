enum EmsGeneration { first, second }

enum EmsChannel { a, b }

class EmsWaveFrame {
  const EmsWaveFrame({
    required this.amplitude,
    required this.frequency,
    required this.pulseWidth,
    this.duration = const Duration(milliseconds: 100),
  });

  final double amplitude;
  final int frequency;
  final int pulseWidth;
  final Duration duration;
}

class EmsProtocol {
  static const int maxDisplayIntensity = 180;
  static const int maxDeviceIntensity = 276;

  // 爆炸冲击波：瞬间达到峰值，随后按频率、脉宽和输出量共同快速衰减。
  static const List<EmsWaveFrame> explosionShockwave = [
    EmsWaveFrame(amplitude: 1.00, frequency: 100, pulseWidth: 100),
    EmsWaveFrame(amplitude: 0.82, frequency: 88, pulseWidth: 88),
    EmsWaveFrame(amplitude: 0.62, frequency: 75, pulseWidth: 76),
    EmsWaveFrame(amplitude: 0.46, frequency: 62, pulseWidth: 64),
    EmsWaveFrame(amplitude: 0.34, frequency: 50, pulseWidth: 52),
    EmsWaveFrame(amplitude: 0.24, frequency: 40, pulseWidth: 42),
    EmsWaveFrame(amplitude: 0.15, frequency: 30, pulseWidth: 32),
    EmsWaveFrame(amplitude: 0.08, frequency: 20, pulseWidth: 22),
  ];

  static int toDeviceIntensity(int displayIntensity) {
    if (displayIntensity == 0) return 0;
    final safeValue = displayIntensity.clamp(1, maxDisplayIntensity);
    return (safeValue * maxDeviceIntensity / maxDisplayIntensity).round().clamp(
      1,
      maxDeviceIntensity,
    );
  }

  static List<int> buildRealtimeModePacket({
    required EmsGeneration generation,
    EmsChannel? channel,
    required int displayIntensity,
    required int frequency,
    required int pulseWidth,
  }) {
    final intensity = toDeviceIntensity(displayIntensity);
    final high = intensity >> 8;
    final low = intensity & 0xff;
    final active = intensity > 0;
    final safeFrequency = active ? frequency.clamp(1, 100) : 0;
    final safePulseWidth = active ? pulseWidth.clamp(0, 100) : 0;

    final packet = switch (generation) {
      EmsGeneration.first => <int>[
        0x35,
        0x11,
        switch (channel) {
          EmsChannel.a => 0x01,
          EmsChannel.b => 0x02,
          null => 0x03,
        },
        active ? 0x01 : 0x00,
        high,
        low,
        0x11,
        safeFrequency,
        safePulseWidth,
      ],
      EmsGeneration.second => <int>[
        0x35,
        0x11,
        0x02,
        channel == EmsChannel.b ? 0x00 : high,
        channel == EmsChannel.b ? 0x00 : low,
        channel == EmsChannel.b ? 0x00 : safeFrequency,
        channel == EmsChannel.b ? 0x00 : safePulseWidth,
        channel == EmsChannel.a ? 0x00 : high,
        channel == EmsChannel.a ? 0x00 : low,
        channel == EmsChannel.a ? 0x00 : safeFrequency,
        channel == EmsChannel.a ? 0x00 : safePulseWidth,
      ],
    };

    return [...packet, _checksum(packet)];
  }

  static int _checksum(List<int> bytes) {
    return bytes.fold<int>(0, (sum, byte) => sum + byte) & 0xff;
  }
}
