import 'package:blue_demo/ui/page/controller/controller_page.dart';
import 'package:blue_demo/ui/page/monitor/monitor.dart';
import 'package:blue_demo/ui/page/state/state_page.dart';
import 'package:blue_demo/ui/page/task/task_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentPage = 0;
  var _lastQuitTime = DateTime.now();

  final _page = [
    const StatePage(key: ValueKey('State')),
    const ControllerPage(key: ValueKey('Controller')),
    const TaskPage(key: ValueKey('TaskPage')),
    const MonitorPage(key: ValueKey('MonitorPage')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (DateTime.now().difference(_lastQuitTime).inSeconds > 1) {
            BotToast.showText(text: '再按一次退出');
            _lastQuitTime = DateTime.now();
            return false;
          } else {
            return true;
          }
        },
        child: AnimatedSwitcher(
          child: _page[_currentPage],
          duration: const Duration(milliseconds: 300),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
            ),
            label: '状态',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
            ),
            label: '控制',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list_alt,
            ),
            label: '任务',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.camera_alt,
            ),
            label: '监控',
          ),
        ],
      ),
    );
  }
}
