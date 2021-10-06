import 'package:blue_demo/data/database/database.dart';
import 'package:blue_demo/data/database/database_helper.dart';
import 'package:blue_demo/ui/page/task/task_maker.dart';
import 'package:flutter/material.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TaskMaker()));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    return StreamBuilder<List<TaskTableData>>(
      stream: DB().taskDao.getAllStream(),
      initialData: const [],
      builder: (context, snapshot) {
        return ListView(
          children: snapshot.data!.map((e) {
            return ListTile(
              title: Text(e.name),
            );
          }).toList(),
        );
      },
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('任务', style: TextStyle(fontSize: 18)),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
