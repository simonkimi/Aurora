import 'package:blue_demo/data/database/database_helper.dart';
import 'package:blue_demo/data/database/entity/task_entity.dart';
import 'package:blue_demo/utils/get_cmykw.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';

part 'task_store.g.dart';

class TaskStore = TaskStoreBase with _$TaskStore;

abstract class TaskStoreBase with Store {
  Future<void> init() async {
    taskList.addAll(await DB().taskDao.getAll());
    print('length ${taskList.length}');
  }

  final taskList = ObservableList<TaskEntity>();

  @action
  Future<void> onListChange(int oldIndex, int newIndex) async {
    print('$oldIndex, $newIndex');
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final child = taskList.removeAt(oldIndex);
    taskList.insert(newIndex, child);

    await save();
  }

  @action
  Future<void> onDelete(TaskEntity entity) async {
    taskList.remove(entity);
    await DB().taskDao.deleteTask(entity);
    await save();
  }

  Future<void> save() async {
    for (int index = 0; index < taskList.length; index++) {
      await DB().taskDao.updateTask(taskList[index]..sort = index);
    }
  }

  @action
  Future<void> addTask(int colorInt) async {
    final color = Color(colorInt);
    final cmykw = CMYKWUtil(null).RGB_CMYG(color);
    final taskEntity = TaskEntity(
      color: colorInt,
      c: cmykw.c,
      m: cmykw.m,
      y: cmykw.y,
      k: cmykw.k,
      w: cmykw.w,
      sort: taskList.length,
    );
    final id = await DB().taskDao.addTask(taskEntity);
    taskList.add(taskEntity..id = id);
  }
}
