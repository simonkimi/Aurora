import 'package:aurora/data/proto/gen/task.pb.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobx/mobx.dart';

part 'task_maker_store.g.dart';

class TaskMakerStore = TaskMakerStoreBase with _$TaskMakerStore;

class LoopTask {
  LoopTask({
    required this.colorList,
    required this.loop,
  });

  final RxList<Color> colorList;
  final Rx<int> loop;
}

abstract class TaskMakerStoreBase with Store {
  TaskMakerStoreBase([TaskPb? taskPb])
      : palette = taskPb != null
            ? taskPb.colorList.map((e) => e.color).toList().obs
            : RxList<Color>(),
        loop = taskPb != null
            ? taskPb.loop
                .map((e) => LoopTask(
                    colorList: e.colorList.map((e) => e.color).toList().obs,
                    loop: e.loopTime.obs))
                .toList()
                .obs
            : RxList<LoopTask>(),
        name = taskPb?.name ?? '';

  final RxList<Color> palette;

  final RxList<LoopTask> loop;

  final editIndex = 0.obs;

  String name;

  TaskPb transformToPb() {
    return TaskPb(
        name: name,
        colorList: palette.map((e) => e.pb).toList(),
        loop: loop
            .map((e) => LooperPb(
                colorList: e.colorList.map((e) => e.pb).toList(),
                loopTime: e.loop.value))
            .toList());
  }

  bool isMaxSize() {
    var size = 0;
    for (final l in loop) {
      size += l.colorList.length + 4;
    }

    return size >= 50;
  }

  String? addPaletteColor(Color color) {
    if (loop.isNotEmpty) {
      final colorList = loop[editIndex.value].colorList;
      colorList.add(color);
      if (isMaxSize()) {
        colorList.removeAt(colorList.length - 1);
        return '已达到最大值';
      }
    }
  }

  void removePaletteColor(int index) {
    palette.removeAt(index);
  }
}

extension ColorTransform on ColorPb {
  Color get color => Color.fromARGB(0xFF, red, green, blue);
}

extension ColorPbTransform on Color {
  ColorPb get pb => ColorPb(red: red, green: green, blue: blue);
}
