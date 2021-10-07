import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/database/database_helper.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/ui/page/task/task_maker.dart';
import 'package:flutter/material.dart';
import 'store/task_maker_store.dart';

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final pb = await Navigator.of(context).push<TaskPb?>(
              MaterialPageRoute(builder: (context) => TaskMaker()));
          if (pb != null) {
            DB()
                .taskDao
                .insert(TaskTableCompanion.insert(taskPb: pb.writeToBuffer()));
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: StreamBuilder<List<TaskTableData>>(
        stream: DB().taskDao.getAllStream(),
        initialData: const [],
        builder: (context, snapshot) {
          return buildListView(snapshot);
        },
      ),
    );
  }

  ListView buildListView(AsyncSnapshot<List<TaskTableData>> snapshot) {
    return ListView(
      children: snapshot.data!.map((e) {
        final pb = TaskPb.fromBuffer(e.taskPb);
        return Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                buildPaletteList(pb),
                const SizedBox(height: 10),
                buildLoopList(pb),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget buildPaletteList(TaskPb pb) {
    return SizedBox(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.palette, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: pb.colorList.length,
              itemBuilder: (context, index) {
                return buildColorCircular(pb.colorList[index].color);
              },
              separatorBuilder: (context, index) {
                return const SizedBox(width: 5);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildLoopList(TaskPb pb) {
    return Row(
      children: [
        const Icon(Icons.format_list_bulleted_rounded),
        const SizedBox(width: 10),
        Expanded(
          child: SizedBox(
            height: 30,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              separatorBuilder: (context, index) {
                return const SizedBox(width: 10);
              },
              itemCount: pb.loop.length,
              itemBuilder: (c, i) => _buildLoopItem(c, i, pb),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoopItem(BuildContext context, int index, TaskPb pb) {
    final loop = pb.loop[index];
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          ...loop.colorList.map((e) {
            return Padding(
              padding: const EdgeInsets.all(3),
              child: buildColorCircular(e.color),
            );
          }),
          Text(' × ${loop.loopTime}'),
        ],
      ),
    );
  }

  Widget buildColorCircular(Color color) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
        ),
      ),
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
