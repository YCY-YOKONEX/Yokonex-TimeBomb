import 'package:flutter/material.dart';

import '../ems/ems_controller.dart';
import '../ems/ems_protocol.dart';
import '../l10n/l10n.dart';
import '../main.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({super.key});

  @override
  State<DevicePage> createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  final EmsController _controller = EmsController.instance;

  @override
  void initState() {
    super.initState();
    _controller.startScan();
  }

  @override
  void dispose() {
    _controller.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.punishmentDevices),
        actions: [
          IconButton(
            onPressed: _controller.stopAll,
            tooltip: context.l10n.stopAll,
            icon: const Icon(Icons.stop_circle_outlined),
          ),
        ],
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Column(
            children: [
              _StatusBand(controller: _controller),
              Expanded(
                child: _controller.devices.isEmpty
                    ? const _EmptyDevices()
                    : Align(
                        alignment: Alignment.topCenter,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 840),
                          child: ListView.separated(
                            padding: const EdgeInsets.all(20),
                            itemCount: _controller.devices.length,
                            separatorBuilder: (_, _) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              return _DeviceTile(
                                device: _controller.devices[index],
                                controller: _controller,
                              );
                            },
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return FloatingActionButton.extended(
            onPressed: _controller.isScanning ? null : _controller.startScan,
            icon: _controller.isScanning
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.bluetooth_searching_rounded),
            label: Text(
              _controller.isScanning
                  ? context.l10n.searching
                  : context.l10n.searchAgain,
            ),
          );
        },
      ),
    );
  }
}

class _StatusBand extends StatelessWidget {
  const _StatusBand({required this.controller});

  final EmsController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: TimeBombApp.coal,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 840),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 13, 20, 14),
            child: Row(
              children: [
                Icon(
                  controller.connectedCount > 0
                      ? Icons.bluetooth_connected_rounded
                      : Icons.bluetooth_rounded,
                  color: controller.connectedCount > 0
                      ? TimeBombApp.mint
                      : Colors.white54,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    context.l10n.connectionSummary(
                      controller.connectedCount,
                      controller.connectedChannelSlots.length,
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyDevices extends StatelessWidget {
  const _EmptyDevices();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.portable_wifi_off_rounded,
              size: 52,
              color: Colors.black38,
            ),
            const SizedBox(height: 14),
            Text(
              context.l10n.turnOnDevices,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
            ),
          ],
        ),
      ),
    );
  }
}

class _DeviceTile extends StatelessWidget {
  const _DeviceTile({required this.device, required this.controller});

  final EmsDeviceRecord device;
  final EmsController controller;

  @override
  Widget build(BuildContext context) {
    final stateColor = device.isConnected
        ? TimeBombApp.mint
        : device.isConnecting
        ? TimeBombApp.signalYellow
        : Colors.black26;

    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: stateColor, width: device.isConnected ? 2 : 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  device.isConnected
                      ? Icons.bolt_rounded
                      : Icons.bluetooth_rounded,
                  color: device.isConnected
                      ? TimeBombApp.warningRed
                      : Colors.black45,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        device.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        '${device.device.rssi} dBm · ${device.id}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: device.isConnecting
                      ? null
                      : device.isConnected
                      ? () => controller.disconnect(device)
                      : () => controller.connect(device),
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(82, 42),
                    backgroundColor: device.isConnected
                        ? Colors.black54
                        : TimeBombApp.coal,
                  ),
                  child: Text(
                    device.isConnecting
                        ? context.l10n.connecting
                        : device.isConnected
                        ? context.l10n.disconnect
                        : context.l10n.connect,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                const Icon(Icons.memory_rounded, size: 18),
                const SizedBox(width: 8),
                Text(
                  device.generation == EmsGeneration.first
                      ? context.l10n.firstGeneration
                      : context.l10n.secondGeneration,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _ChannelBadge(label: 'A', enabled: device.isConnected),
                const SizedBox(width: 8),
                _ChannelBadge(label: 'B', enabled: device.isConnected),
              ],
            ),
            if (device.errorKind != null) ...[
              const SizedBox(height: 8),
              Text(
                _localizedError(context),
                style: const TextStyle(
                  color: TimeBombApp.warningRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _localizedError(BuildContext context) {
    final detail = device.errorDetail ?? '';
    return switch (device.errorKind!) {
      EmsDeviceErrorKind.connection => context.l10n.connectionFailed(detail),
      EmsDeviceErrorKind.waveformTest => context.l10n.waveformTestFailed(
        detail,
      ),
      EmsDeviceErrorKind.trigger => context.l10n.triggerFailed(detail),
      EmsDeviceErrorKind.stop => context.l10n.stopFailed(detail),
      EmsDeviceErrorKind.emergencyStop => context.l10n.emergencyStopFailed(
        detail,
      ),
    };
  }
}

class _ChannelBadge extends StatelessWidget {
  const _ChannelBadge({required this.label, required this.enabled});

  final String label;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: enabled ? TimeBombApp.mint : const Color(0xFFEAE7DF),
        shape: BoxShape.circle,
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900)),
    );
  }
}
