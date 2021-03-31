import 'dart:ui';
import 'package:blue_demo/ui/data/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  bool _showNoName = false;
  bool _isConnecting = false;

  @override
  void initState() {
    super.initState();
    FlutterBlue.instance.startScan(timeout: Duration(seconds: 10));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Stack(
        children: [
          IgnorePointer(
            ignoring: _isConnecting,
            child: buildBody(),
          ),
          if (_isConnecting)
            Center(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: CircularProgressIndicator(),
              ),
            )
        ],
      ),
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
          child: snapshot.data!
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
                  child: const Icon(Icons.bluetooth_disabled),
                  onPressed: () {
                    mainStore.findAndConnect();
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
                                    icon: Icon(Icons.send),
                                    onPressed: () async {
                                    setState(() {
                                      _isConnecting = true;
                                    });
                                    try {
                                      await mainStore.connectDevice(e, true);
                                      Navigator.of(context).pop();
                                    } on Exception catch(e) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('连接失败: $e')));
                                    } finally {
                                      setState(() {
                                        _isConnecting = false;
                                      });
                                    }
                                  },
                                  );
                                }
                                return SizedBox();
                              },
                            ),
                          ),
                        );
                      }).toList() ??
                      [],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 4),
              child: Row(
                children: [
                  const Text(
                    '可用设备',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const Expanded(child: SizedBox()),
                  SizedBox(
                    child: IconButton(
                      icon: Icon(_showNoName
                          ? Icons.filter_alt_outlined
                          : Icons.filter_alt),
                      onPressed: () {
                        setState(() {
                          _showNoName = !_showNoName;
                        });
                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: Duration(seconds: 1),
                          content: Text(_showNoName ? '显示所有设备' : '隐藏匿名设备'),
                        ));
                      },
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),
            StreamBuilder<List<ScanResult>>(
              stream: FlutterBlue.instance.scanResults,
              builder: (_, snapshot) {
                return Column(
                  children: snapshot.data?.where((e) {
                        return e.device.name.isNotEmpty || _showNoName;
                      }).map((e) {
                        return Card(
                          child: ListTile(
                            leading: Icon(Icons.bluetooth),
                            title: Text(
                              e.device.name.isNotEmpty
                                  ? e.device.name
                                  : e.device.id.id,
                            ),
                            subtitle: Text(e.device.id.id),
                            onTap: () async {
                              setState(() {
                                _isConnecting = true;
                              });
                              try {
                                await mainStore.connectDevice(e.device);
                                Navigator.of(context).pop();
                              } on Exception catch(e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('连接失败: $e')));
                              } finally {
                                setState(() {
                                  _isConnecting = false;
                                });
                              }
                            },
                          ),
                        );
                      }).toList() ??
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
