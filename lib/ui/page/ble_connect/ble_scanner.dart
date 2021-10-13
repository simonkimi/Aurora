import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class BleScanner extends StatefulWidget {
  const BleScanner({Key? key}) : super(key: key);

  @override
  _BleScannerState createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  bool useFilter = true;

  @override
  void initState() {
    FlutterBlue.instance.startScan(timeout: const Duration(seconds: 10));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '蓝牙扫描', actions: [
        IconButton(
            onPressed: () {
              setState(() {
                useFilter = !useFilter;
              });
            },
            icon: useFilter
                ? const Icon(Icons.filter_alt)
                : const Icon(Icons.filter_alt_outlined))
      ]),
      body: Scaffold(
        body: buildBody(),
        floatingActionButton: buildSearchFab(),
      ),
    );
  }

  StreamBuilder<bool> buildSearchFab() {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (_, snapshot) {
        return snapshot.data!
            ? FloatingActionButton(
                key: const ValueKey('stop'),
                onPressed: FlutterBlue.instance.stopScan,
                backgroundColor: Colors.red,
                child: const SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.red,
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 3,
                  ),
                ),
              )
            : FloatingActionButton(
                key: const ValueKey('scan'),
                child: const Icon(Icons.search),
                onPressed: () {
                  FlutterBlue.instance
                      .startScan(timeout: const Duration(seconds: 10));
                },
              );
      },
    );
  }

  ListView buildBody() {
    return ListView(
      children: [
        FutureBuilder<List<BluetoothDevice>>(
          future: FlutterBlue.instance.connectedDevices,
          initialData: const [],
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (snapshot.data!.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      '已连接',
                      style: TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ...snapshot.data!.map((e) {
                  return Card(
                    child: ListTile(
                      leading: const CircleAvatar(
                        child: Icon(Icons.bluetooth),
                      ),

                      title: Text(e.name.isEmpty ? 'Anonymous' : e.name),
                      subtitle: Text(e.id.id),
                      onTap: () async {
                        connectDevice(e);
                      },
                    ),
                  );
                })
              ],
            );
          },
        ),
        const SizedBox(height: 5),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            '未连接',
            style: TextStyle(fontSize: 15),
          ),
        ),
        StreamBuilder<List<ScanResult>>(
          initialData: const [],
          stream: FlutterBlue.instance.scanResults,
          builder: (context, snapshot) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: snapshot.data!
                  .where((e) => !useFilter || e.device.name.isNotEmpty)
                  .map((e) {
                return ListTile(
                  title:
                      Text(e.device.name.isEmpty ? 'Anonymous' : e.device.name),
                  subtitle: Text(e.device.id.id),
                  onTap: () async {
                    connectDevice(e.device);
                  },
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Future<void> connectDevice(BluetoothDevice device) async {
    final cancelFunc = BotToast.showLoading();
    try {
      await FlutterBlue.instance.stopScan();
      await bluetoothStore.connectFindDevice(device);
      cancelFunc();
      setState(() {});
      Navigator.of(context).pop();
    } catch (e) {
      cancelFunc();
      BotToast.showText(text: '连接设备失败');
    }
  }
}
