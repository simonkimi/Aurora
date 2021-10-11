import 'dart:typed_data';

import 'package:aurora/ui/page/controller/controller_page.dart';
import 'package:aurora/ui/page/monitor/monitor.dart';
import 'package:aurora/ui/page/state/state_page.dart';
import 'package:aurora/ui/page/task/task_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import '../../../main.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  var _currentPage = 0;
  var _lastQuitTime = DateTime.now();
  var _isOverLayDisplay = false;
  var _isDragStart = false;

  final controller = PageController();

  late Offset _overlayOffset;
  late OverlayEntry overlayEntry;

  @override
  void initState() {
    super.initState();
    _overlayOffset = const Offset(0, 100);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      overlayEntry = buildOverlay();
    });
  }

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
        child: PageView(
          children: _page,
          controller: controller,
          onPageChanged: (index) {
            onPageChange(index);
            setState(() {
              _currentPage = index;
            });
          },
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentPage,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          // onPageChange(_currentPage, value);
          setState(() {
            _currentPage = value;
            controller.jumpToPage(value);
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

  void onPageChange(int target) {
    if (!_isOverLayDisplay &&
        target != _page.length - 1 &&
        monitorStore.ip != null) {
      print('Insert OverLay');
      Overlay.of(context)!.insert(overlayEntry);
      _isOverLayDisplay = true;
    } else if (_isOverLayDisplay && target == _page.length - 1) {
      print('Remove OverLay');
      overlayEntry.remove();
      _isOverLayDisplay = false;
    }
  }

  OverlayEntry buildOverlay() {
    return OverlayEntry(
      builder: (context) {
        final child = SizedBox(
          width: MediaQuery.of(context).size.width / 3,
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: StreamBuilder<List<int>>(
              stream: monitorStore.videoStream,
              builder: (context, snapshot) {
                if (snapshot.data == null) {
                  return const AspectRatio(
                    aspectRatio: 320 / 240,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return Image.memory(
                  Uint8List.fromList(snapshot.data!),
                  gaplessPlayback: true,
                );
              },
            ),
          ),
        );

        return Positioned(
          left: _overlayOffset.dx,
          top: _overlayOffset.dy,
          child: Draggable(
            child: _isDragStart ? const SizedBox() : child,
            feedback: SizedBox(
              width: MediaQuery.of(context).size.width / 3,
              child: Card(
                child: AspectRatio(
                  aspectRatio: 320 / 240,
                  child: Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.api, size: 40),
                  ),
                ),
              ),
            ),
            onDragEnd: (detail) {
              setState(() {
                // _overlayOffset = detail.offset;

                final size = MediaQuery.of(context).size;

                final width = size.width / 3;
                final height = width / (320 / 240);

                var dx = detail.offset.dx;
                if (dx < 0) dx = 0;
                if (dx > size.width - width) dx = size.width - width;

                var dy = detail.offset.dy;
                if (dy < 0) dy = 0;
                if (dy > size.height - height) dy = size.height - height;

                setState(() {
                  _overlayOffset = Offset(dx, dy);
                });

                _isDragStart = false;
              });
            },
            onDragStarted: () {
              setState(() {
                _isDragStart = true;
              });
            },
          ),
        );
      },
    );
  }
}
