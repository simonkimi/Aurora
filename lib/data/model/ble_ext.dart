import 'package:aurora/data/proto/gen/task.pbserver.dart';
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
  int testSpeed = 100,
}) {
  return [
    direction.value,
    cmykw.c,
    cmykw.m,
    cmykw.y,
    cmykw.k,
    cmykw.w,
    testSpeed,
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
    required this.loop,
  });

  final List<CMYKW> colorList;
  final List<TaskLoop> loop;

  List<int> toBytes() {
    final buffer = <int>[];

    // 颜色数组
    for (final cmykw in colorList) {
      buffer.addAll([
        '&'.codeUnitAt(0),
        cmykw.c,
        cmykw.m,
        cmykw.y,
        cmykw.k,
        cmykw.w,
      ]);
    }

    // 颜色顺序
    for (final loop in loop) {
      buffer.addAll([
        '%'.codeUnitAt(0),
        ...loop.colorList,
        '#'.codeUnitAt(0),
        loop.loopTime % 10,
        loop.loopTime ~/ 10 % 10,
        loop.loopTime ~/ 100 % 10,
      ]);
    }
    buffer.addAll([0xd, 0xa]);

    return buffer;
  }
}
