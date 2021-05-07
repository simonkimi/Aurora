import 'package:blue_demo/ui/page/controller/controller_page.dart';
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

  var _page = [
    StatePage(key: ValueKey('State')),
    ControllerPage(key: ValueKey('Controller')),
    TaskPage(key: ValueKey('TaskPage')),
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
          duration: Duration(milliseconds: 300),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        onTap: (value) {
          setState(() {
            _currentPage = value;
          });
        },
        items: [
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
        ],
      ),
    );
  }
}
