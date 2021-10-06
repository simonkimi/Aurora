import 'package:blue_demo/data/proto/gen/task.pb.dart';
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
            : RxList<LoopTask>();

  final RxList<Color> palette;

  final RxList<LoopTask> loop;

  final editIndex = 0.obs;
}

extension ColorTransform on ColorPb {
  Color get color => Color.fromARGB(0xFF, red, green, blue);
}

extension ColorPbTransform on Color {
  ColorPb get pb => ColorPb(red: red, green: green, blue: blue);
}
