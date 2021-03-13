import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: buildActionButton(),
    );
  }

  Widget buildActionButton() {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (_, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: snapshot.data
              ? FloatingActionButton(
                  key: ValueKey('stop'),
                  onPressed: FlutterBlue.instance.stopScan,
                  backgroundColor: Colors.red,
                  child: SizedBox(
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
                  key: ValueKey('scan'),
                  child: const Icon(Icons.search),
                  onPressed: () {
                    FlutterBlue.instance
                        .startScan(timeout: Duration(seconds: 60));
                  },
                ),
        );
      },
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          children: [
            StreamBuilder<List<BluetoothDevice>>(
              stream: Stream.periodic(Duration(seconds: 2))
                  .asyncMap((_) => FlutterBlue.instance.connectedDevices),
              initialData: [],
              builder: (c, snapshot) {
                return Column(
                  children: snapshot.data?.map((e) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Icon(Icons.bluetooth_audio),
                            ),
                            title: Text(e.name.isNotEmpty ? e.name : e.id.id),
                            subtitle: const Text('已连接'),
                            trailing: StreamBuilder<BluetoothDeviceState>(
                              stream: e.state,
                              initialData: BluetoothDeviceState.disconnected,
                              builder: (_, state) {
                                if (state.data ==
                                    BluetoothDeviceState.connected) {
                                  return IconButton(
                                      icon: Icon(Icons.send), onPressed: () {});
                                }
                                return SizedBox();
                              },
                            ),
                          ),
                        );
                      })?.toList() ??
                      [],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    '可用设备',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            const Divider(),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              builder: (_, snapshot) {
                return Column(
                  children: snapshot.data?.map((e) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.bluetooth),
                            title: Text(e.device.name.isNotEmpty
                                ? e.device.name
                                : e.device.id.id),
                          ),
                        );
                      })?.toList() ??
                      [],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('Discover Device'),
    );
  }
}
