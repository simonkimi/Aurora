import 'package:blue_demo/ui/components/dash_line.dart';
import 'package:blue_demo/ui/data/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

class StatePage extends StatefulWidget {
  const StatePage({Key key}) : super(key: key);
  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage> with TickerProviderStateMixin {
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 3),
    );
    _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return Container(
      color: Colors.blue,
      child: Column(
        children: [
          SizedBox(height: 20),
          Container(
            height: 50,
            child: Center(
              child: SizedBox(
                height: 50,
                width: 50,
                child: Lottie.asset(
                  'assets/lottie/bluetooth.json',
                  controller: _controller,
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          Container(
            height: 100,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.phone_android,
                        color: Colors.white,
                        size: 35,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                  SizedBox(height: 5),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          '就绪',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      Text(
                        '未连接',
                        style: TextStyle(color: Colors.white),
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
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
                child: ListView(
                  children: [
                    Text(
                      '设备',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 10),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFF22F5FF),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: Text('前置电机1'),
                        subtitle: Text('转速 000'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFFFFFF2C),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: Text('前置电机2'),
                        subtitle: Text('转速 000'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFFFF2CD9),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                            color: Colors.white,
                          ),
                        ),
                        title: Text('前置电机3'),
                        subtitle: Text('转速 000'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFF3A3A3A),
                          child: SvgPicture.asset('assets/svg/motor.svg',
                              width: 26, color: Colors.white),
                        ),
                        title: Text('后置电机1'),
                        subtitle: Text('转速 000'),
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Color(0XFFEFF3FF),
                          child: SvgPicture.asset(
                            'assets/svg/motor.svg',
                            width: 26,
                          ),
                        ),
                        title: Text('后置电机2'),
                        subtitle: Text('转速 000'),
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

  Widget buildAppBar() {
    return AppBar(
      title: Text(
        '状态',
        style: TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      elevation: 0,
      automaticallyImplyLeading: false,
    );
  }
}
