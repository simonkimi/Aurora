import 'package:aurora/data/store/bluetooth_store.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/dash_line.dart';
import 'package:aurora/ui/page/ble_connect/ble_scanner.dart';
import 'package:aurora/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class StatePage extends StatefulWidget {
  const StatePage({Key? key}) : super(key: key);

  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  late AnimationController _checkController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _checkController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildAppBar(context, title: '状态'),
      body: Observer(builder: (_) => buildBody()),
    );
  }

  Widget buildHeaderHint() {
    if (bluetoothStore.state == ConnectState.Connected) {
      _checkController.animateTo(0.4);
      return IconButton(
        padding: EdgeInsets.zero,
        icon: SizedBox(
          height: 50,
          width: 50,
          child: Lottie.asset(
            'assets/lottie/checked.json',
            controller: _checkController,
          ),
        ),
        onPressed: () {},
      );
    }

    return StreamBuilder<bool>(
      initialData: false,
      stream: FlutterBlue.instance.isScanning,
      builder: (c, snapshot) {
        if (snapshot.data! ||
            bluetoothStore.state == ConnectState.Connecting ||
            bluetoothStore.state == ConnectState.Scanning) {
          return SizedBox(
            height: 50,
            width: 50,
            child: Lottie.asset(
              'assets/lottie/bluetooth.json',
            ),
          );
        } else {
          return IconButton(
            padding: EdgeInsets.zero,
            icon: const Icon(
              Icons.bluetooth_disabled,
              color: Colors.white,
              size: 50,
            ),
            onPressed: () {
              // bluetoothStore.findAndConnect();
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => const BleScanner()));
            },
          );
        }
      },
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          const SizedBox(height: 20),
          Container(
            height: 50,
            child: Center(
              child: buildHeaderHint(),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            bluetoothStore.stateString,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Row(
                    children: const [
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 35,
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: DashedLine(
                            color: Colors.white,
                            count: 15,
                            width: 8,
                            height: 3,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.print,
                        color: Colors.white,
                        size: 35,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 5),
                        child: Text(
                          '就绪',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const Expanded(child: SizedBox()),
                      Text(
                        bluetoothStore.connectedDevice != null ? '已连接' : '未连接',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: ListView(
                  children: [
                    const Text(
                      '设备',
                      style: TextStyle(fontSize: 20),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff22f5ff),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: const Text('前置电机1'),
                        subtitle: Text('转速 ${mainStore.nowCmykw.c.to3()}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffffff2c),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: const Text('前置电机2'),
                        subtitle: Text('转速 ${mainStore.nowCmykw.y.to3()}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffff2cd9),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                            color: Colors.white,
                          ),
                        ),
                        title: const Text('前置电机3'),
                        subtitle: Text('转速 ${mainStore.nowCmykw.m.to3()}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff3a3a3a),
                          child: SvgPicture.asset('assets/svg/motor.svg',
                              width: 26, color: Colors.white),
                        ),
                        title: const Text('后置电机1'),
                        subtitle: Text('转速 ${mainStore.nowCmykw.k.to3()}'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xffeff3ff),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: const Text('后置电机2'),
                        subtitle: Text('转速 ${mainStore.nowCmykw.w.to3()}'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
