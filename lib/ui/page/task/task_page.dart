import 'dart:convert';

import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/database/database_helper.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/select_tile.dart';
import 'package:aurora/ui/page/qr_code/qr_gen.dart';
import 'package:aurora/ui/page/qr_code/qr_scanner.dart';
import 'package:aurora/ui/page/task/task_maker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'store/task_maker_store.dart';

enum TaskSelection { Send, Edit, Share, Delete }

class TaskPage extends StatelessWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context,
          title: '任务',
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/history');
              },
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: () => onScanPress(context),
              icon: const Icon(Icons.qr_code),
            ),
          ],
          displayBack: false),
      body: buildBody(context),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
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
    );
  }

  Widget buildBody(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: StreamBuilder<List<TaskTableData>>(
        stream: DB().taskDao.getAllStream(),
        initialData: const [],
        builder: (context, snapshot) {
          return buildListView(context, snapshot);
        },
      ),
    );
  }

  ListView buildListView(
      BuildContext context, AsyncSnapshot<List<TaskTableData>> snapshot) {
    return ListView(
      children: snapshot.data!.map((e) {
        final pb = TaskPb.fromBuffer(e.taskPb);

        final dialog = () async {
          final selection = await showSelectDialog<TaskSelection>(
              context: context,
              items: const [
                SelectTileItem(title: '发送', value: TaskSelection.Send),
                SelectTileItem(title: '编辑', value: TaskSelection.Edit),
                SelectTileItem(title: '分享', value: TaskSelection.Share),
                SelectTileItem(title: '删除', value: TaskSelection.Delete),
              ],
              title: '配置',
              displayRadio: false);
          switch (selection) {
            case TaskSelection.Send:
              try {
                await bluetoothStore.sendTask(pb);
                BotToast.showText(text: '已发送');
              } catch (e) {
                BotToast.showText(text: e.toString());
              }
              break;
            case TaskSelection.Share:
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => QrGen(buffer: base64Encode(e.taskPb))));
              break;
            case TaskSelection.Delete:
              DB().taskDao.remove(e);
              break;
            case TaskSelection.Edit:
              final pb =
                  await Navigator.of(context).push<TaskPb>(MaterialPageRoute(
                      builder: (context) => TaskMaker(
                            tableData: e,
                          )));
              if (pb != null) {
                DB().taskDao.replace(e.copyWith(taskPb: pb.writeToBuffer()));
              }
              break;
            case null:
              break;
          }
        };

        return Card(
          child: InkWell(
            onTap: dialog,
            onLongPress: dialog,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(pb.name),
                  buildPaletteList(pb),
                  const SizedBox(height: 10),
                  buildLoopList(pb),
                ],
              ),
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
          child: Wrap(
            runSpacing: 5,
            spacing: 10,
            children: pb.loop.map((e) => _buildLoopItem(e, pb)).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildLoopItem(LooperPb loop, TaskPb pb) {
    return Container(
      height: 30,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: const BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
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

  Future<void> onScanPress(BuildContext context) async {
    final scan = await Navigator.of(context).push<String?>(
        MaterialPageRoute(builder: (context) => const QrScanner()));
    try {
      if (scan != null) {
        final pb = TaskPb.fromBuffer(base64Decode(scan));
        final entity = TaskTableCompanion.insert(taskPb: pb.writeToBuffer());
        DB().taskDao.insert(entity);
        BotToast.showText(text: '导入完成');
      }
    } catch (e) {
      BotToast.showText(text: '二维码扫描失败');
    }
  }
}
