import 'package:blue_demo/ui/page/controller/controller_page.dart';
import 'package:blue_demo/ui/page/state/state_page.dart';
import 'package:blue_demo/ui/page/task/task_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentPage = 0;
  var _page = [
    StatePage(key: ValueKey('State')),
    ControllerPage(key: ValueKey('Controller')),
    TaskPage(key: ValueKey('TaskPage')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        child: _page[_currentPage],
        duration: Duration(milliseconds: 300),
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
