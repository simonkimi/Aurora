import 'dart:math';

import 'package:blue_demo/ui/components/blue_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class DevicePage extends StatefulWidget {
  const DevicePage({Key key, this.device}) : super(key: key);
  final BluetoothDevice device;

  @override
  _DevicePageState createState() => _DevicePageState();
}

class _DevicePageState extends State<DevicePage> {
  List<int> _getRandomBytes() {
    return [12, 34, 56, 78, 90];
  }

  Future<void> test() async {
    final serviceList = await widget.device.discoverServices();
    serviceList.forEach((element) {
      print(element.uuid.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    test();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Device'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<BluetoothService>>(
              stream: widget.device?.services,
              initialData: [],
              builder: (_, snapshot) {
                return Column(
                  children: _buildServiceTiles(snapshot.data),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildServiceTiles(List<BluetoothService> services) {
    return services
            ?.map(
              (s) => ServiceTile(
                service: s,
                characteristicTiles: s?.characteristics
                        ?.map(
                          (c) => CharacteristicTile(
                            characteristic: c,
                            onReadPressed: () => c.read(),
                            onWritePressed: () async {
                              await c.write(_getRandomBytes(),
                                  withoutResponse: true);
                              print('Receive Data: ${await c.read()}');
                            },
                            onNotificationPressed: () async {
                              await c.setNotifyValue(!c.isNotifying);
                              print('Notification Data: ${await c.read()}');
                            },
                            descriptorTiles: c.descriptors
                                .map(
                                  (d) => DescriptorTile(
                                    descriptor: d,
                                    onReadPressed: () => d.read(),
                                    onWritePressed: () =>
                                        d.write(_getRandomBytes()),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                        ?.toList() ??
                    [],
              ),
            )
            ?.toList() ??
        [];
  }
}
