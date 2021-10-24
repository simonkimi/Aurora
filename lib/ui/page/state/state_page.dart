import 'dart:async';
import 'dart:math';
import 'package:aurora/data/store/bluetooth_store.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/dash_line.dart';
import 'package:aurora/ui/page/ble_connect/ble_scanner.dart';
import 'package:aurora/utils/event_bus.dart';
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

  late StreamSubscription bleMessage;

  late AnimationController _cController;
  late AnimationController _mController;
  late AnimationController _yController;
  late AnimationController _kController;
  late AnimationController _wController;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _checkController =
        AnimationController(duration: const Duration(seconds: 4), vsync: this);

    _cController = AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _mController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    _yController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    _kController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _wController = AnimationController(
        duration: const Duration(milliseconds: 1200), vsync: this);

    bleMessage = Bus().on<EventBleSpeed>().listen((EventBleSpeed event) {
      setSpeed(_cController, event.c);
      setSpeed(_mController, event.m);
      setSpeed(_yController, event.y);
      setSpeed(_kController, event.k);
      setSpeed(_wController, event.w);
    });
  }

  void setSpeed(AnimationController controller, int speed) {
    if (speed == 0) {
      controller.stop();
    } else {
      controller.duration = Duration(milliseconds: (200 + 2000 - log(speed) * (2000 / log(200))).floor());
      controller.repeat();
    }
  }

  @override
  void dispose() {
    _checkController.dispose();
    _cController.dispose();
    _mController.dispose();
    _yController.dispose();
    _kController.dispose();
    _wController.dispose();
    bleMessage.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildAppBar(context, title: '状态', displayBack: false),
      body: Observer(builder: (_) => buildBody()),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          const SizedBox(height: 20),
          buildConnectBtn(),
          const SizedBox(height: 10),
          Text(
            bluetoothStore.stateString,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          buildStateLine(),
          buildColorList()
        ],
      ),
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
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const BleScanner()));
            },
          );
        }
      },
    );
  }

  Widget _buildCard({
    required Color color,
    required String title,
    required String subTitle,
    required AnimationController controller,
  }) {
    return Card(
      child: ListTile(
        leading: RotationTransition(
          turns: controller,
          child: CircleAvatar(
            backgroundColor: color,
            child: SvgPicture.asset(
              'assets/svg/motor.svg',
              width: 26,
              color: color.isDark() ? Colors.white : Colors.black,
            ),
          ),
        ),
        title: Text(title),
        subtitle: Text(subTitle),
      ),
    );
  }

  Expanded buildColorList() {
    return Expanded(
      child: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
          child: ListView(
            children: [
              const Text(
                '设备',
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 10),
              _buildCard(
                color: const Color(0xff22f5ff),
                title: '入料电机 - C',
                subTitle: '转速 ${mainStore.nowCmykw.c.to3()}',
                controller: _cController,
              ),
              _buildCard(
                color: const Color(0xffff2cd9),
                title: '入料电机 - M',
                subTitle: '转速 ${mainStore.nowCmykw.m.to3()}',
                controller: _mController,
              ),
              _buildCard(
                color: const Color(0xffffff2c),
                title: '入料电机 - Y',
                subTitle: '转速 ${mainStore.nowCmykw.y.to3()}',
                controller: _yController,
              ),
              _buildCard(
                color: const Color(0xff3a3a3a),
                title: '入料电机 - K',
                subTitle: '转速 ${mainStore.nowCmykw.k.to3()}',
                controller: _kController,
              ),
              _buildCard(
                color: const Color(0xffeff3ff),
                title: '入料电机 - W',
                subTitle: '转速 ${mainStore.nowCmykw.w.to3()}',
                controller: _wController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildStateLine() {
    return Container(
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
    );
  }

  Container buildConnectBtn() {
    return Container(
      height: 50,
      child: Center(
        child: buildHeaderHint(),
      ),
    );
  }
}
