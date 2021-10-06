import 'package:blue_demo/main.dart';
import 'package:blue_demo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.send),
      ),
    );
  }

  Widget buildBody() {
    return SizedBox();
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text('任务', style: TextStyle(fontSize: 18)),
      centerTitle: true,
      automaticallyImplyLeading: false,
    );
  }
}
