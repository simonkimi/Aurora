import 'package:flutter/material.dart';
import 'package:blue_demo/main.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:blue_demo/utils/utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(taskStore.taskList
              .map((e) => (e.color & 0x00FFFFFF).toRadixString(16)));
        },
        child: Icon(Icons.send),
      ),
    );
  }

  Widget buildBody() {
    return Observer(builder: (_) {
      return ReorderableListView(
        onReorder: taskStore.onListChange,
        children: taskStore.taskList.map((e) {
          return Slidable(
            key: ValueKey('Task_${e.id}'),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(e.color),
              ),
              title: Text(
                  '#${(e.color & 0x00FFFFFF).toRadixString(16).fill('0', 6)}'),
              subtitle: Text(
                  'C: ${e.c.toP()}  M: ${e.m.toP()}  Y: ${e.y.toP()}  K: ${e.k.toP()}  W: ${e.w.toP()}'),
            ),
            actionPane: SlidableDrawerActionPane(),
            secondaryActions: [
              IconSlideAction(
                caption: '删除',
                color: Colors.red,
                icon: Icons.delete,
                onTap: () => taskStore.onDelete(e),
              ),
            ],
          );
        }).toList(),
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('任务', style: TextStyle(fontSize: 18)),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
