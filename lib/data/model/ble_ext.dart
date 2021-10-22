import 'dart:ui';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/utils/get_cmykw.dart';

extension TaskPbH on TaskPb {}

enum MotorDirection { Stop, Forward, Reverse }

extension MotorDirectionValue on MotorDirection {
  int get value {
    switch (this) {
      case MotorDirection.Stop:
        return 0;
      case MotorDirection.Forward:
        return 1;
      case MotorDirection.Reverse:
        return 2;
    }
  }
}

List<int> buildBluetooth({
  required MotorDirection direction,
  required CMYKW cmykw,
  required Color color,
}) {
  return [
    '*'.codeUnitAt(0),
    direction.value,
    cmykw.c,
    cmykw.m,
    cmykw.y,
    cmykw.k,
    cmykw.w,
    mainStore.cmykwConfig.platformSpeed.toInt(),
    '+'.codeUnitAt(0),
    color.red,
    color.green,
    color.blue,
    0x0d,
    0x0a
  ];
}

class TaskLoop {
  TaskLoop({
    required this.colorList,
    required this.loopTime,
  });

  final List<int> colorList;
  final int loopTime;
}

class TaskMessage {
  TaskMessage({
    required this.colorList,
    required this.cmykwList,
    required this.loop,
  });

  final List<Color> colorList;
  final List<CMYKW> cmykwList;
  final List<TaskLoop> loop;

  List<int> toBytes() {
    final buffer = <int>['&'.codeUnitAt(0)];
    // 颜色数组
    for (var i = 0; i < colorList.length; i++) {
      final cmykw = cmykwList[i];
      final color = colorList[i];
      buffer.addAll([
        MotorDirection.Forward.value, // 送料
        cmykw.c,
        cmykw.m,
        cmykw.y,
        cmykw.k,
        cmykw.w,
        color.red,
        color.green,
        color.blue,
      ]);
    }

    buffer.add('%'.codeUnitAt(0));
    // 颜色顺序
    for (final l in loop) {
      buffer.addAll([
        ...l.colorList,
        '#'.codeUnitAt(0),
        l.loopTime ~/ 100 % 10,
        l.loopTime ~/ 10 % 10,
        l.loopTime % 10,
      ]);
    }

    buffer.addAll([0xd, 0xa]);
    return buffer;
  }
}

class BleReceive {}
