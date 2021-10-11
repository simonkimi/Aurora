import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/color_selector.dart';
import 'package:aurora/ui/components/select_tile.dart';
import 'package:aurora/ui/page/task/store/task_maker_store.dart';
import 'package:aurora/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ColorPicker { Choice, Input, Default }

class TaskMaker extends StatelessWidget {
  TaskMaker({Key? key, TaskTableData? tableData})
      : store = TaskMakerStore(
          tableData != null ? TaskPb.fromBuffer(tableData.taskPb) : null,
        ),
        super(key: key);

  final TaskMakerStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '新建任务'),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(context),
    );
  }

  FloatingActionButton buildFloatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (store.loop.isNotEmpty) {
          final pb = store.transformToPb();
          print('生成PB, 大小${pb.writeToBuffer().length}');
          Navigator.of(context).pop(pb);
        }
      },
      child: const Icon(Icons.check),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        buildInputName(),
        buildPalette(),
        buildLoopList(),
      ],
    );
  }

  Padding buildInputName() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: TextFormField(
        initialValue: store.name,
        decoration: const InputDecoration(labelText: '名称'),
        onChanged: (value) {
          store.name = value;
        },
      ),
    );
  }

  Expanded buildLoopList() {
    return Expanded(
      child: Obx(() {
        return ListView(
          children: [
            ...store.loop
                .asMap()
                .map((key, value) => MapEntry(key, buildLoopCard(key, value)))
                .values
                .toList(),
            buildAddLoopBtn()
          ],
        );
      }),
    );
  }

  InkWell buildAddLoopBtn() {
    return InkWell(
      onTap: () {
        store.loop.add(LoopTask(colorList: RxList<Color>(), loop: RxInt(1)));
        store.editIndex.value = store.loop.length - 1;
        if (store.isMaxSize()) {
          BotToast.showText(text: '已达到最大值');
          store.loop.removeAt(store.loop.length - 1);
          store.editIndex.value = store.loop.length - 1;
        }
      },
      child: const Card(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Center(
            child: Icon(Icons.add),
          ),
        ),
      ),
    );
  }

  Padding buildPalette() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: SizedBox(
        child: Card(
          child: Padding(
            padding:
                const EdgeInsets.only(top: 5, right: 5, left: 5, bottom: 10),
            child: Column(
              children: [
                const Text('调色板'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Obx(() => buildPaletteColorList()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLoopCard(int loopIndex, LoopTask loopValue) {
    return Obx(() {
      return Card(
        color: loopIndex == store.editIndex.value ? Colors.grey[200] : null,
        child: InkWell(
          onTap: () {
            store.editIndex.value = loopIndex;
          },
          onLongPress: () {
            store.loop.removeAt(loopIndex);
            if (store.editIndex.value >= store.loop.length) {
              store.editIndex.value = store.loop.length - 1;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Text('循环 ${loopIndex + 1}'),
                const SizedBox(height: 3),
                SizedBox(
                  height: 30,
                  child: Obx(() => buildLoopColorList(loopIndex, loopValue)),
                ),
                buildLoopTextField(loopIndex)
              ],
            ),
          ),
        ),
      );
    });
  }

  Row buildLoopTextField(int loopIndex) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Icon(Icons.loop),
        const SizedBox(width: 10),
        Obx(() {
          if (store.editIndex.value == loopIndex) {
            return SizedBox(
              width: 50,
              child: TextFormField(
                initialValue: store.loop[loopIndex].loop.value.toString(),
                decoration: const InputDecoration(
                  isDense: true,
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (text) {
                  store.loop[loopIndex].loop.value = int.tryParse(text) ?? 1;
                },
              ),
            );
          } else {
            return Text(store.loop[loopIndex].loop.value.toString());
          }
        }),
      ],
    );
  }

  ListView buildLoopColorList(int loopIndex, LoopTask loopValue) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: loopValue.colorList.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, colorIndex) {
        return InkWell(
          onTap: () {
            if (loopIndex == store.editIndex.value) {
              loopValue.colorList.removeAt(colorIndex);
              vibrate(duration: 50);
            } else {
              store.editIndex.value = loopIndex;
            }
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: loopValue.colorList[colorIndex],
                borderRadius: const BorderRadius.all(
                  Radius.circular(50),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  ListView buildPaletteColorList() {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: store.palette.length + 1,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, index) {
        if (index == store.palette.length) {
          return InkWell(
            onTap: () {
              showColorTile(context);
            },
            child: AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: const BorderRadius.all(Radius.circular(50)),
                ),
                child: const Icon(Icons.add),
              ),
            ),
          );
        }
        return InkWell(
          onTap: () {
            final color = store.palette[index];
            final msg = store.addPaletteColor(color);
            if (msg != null) {
              BotToast.showText(text: msg);
            }
          },
          onLongPress: () {
            store.removePaletteColor(index);
          },
          child: buildColorCircular(store.palette[index]),
        );
      },
    );
  }

  Widget buildColorCircular(Color color) {
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(
            Radius.circular(50),
          ),
        ),
      ),
    );
  }

  Future<void> showColorTile(BuildContext context) async {
    final selector = await showSelectDialog<ColorPicker>(
      context: context,
      displayRadio: false,
      items: [
        const SelectTileItem(title: '自选颜色', value: ColorPicker.Choice),
        const SelectTileItem(title: '精确颜色', value: ColorPicker.Input),
        const SelectTileItem(title: '预设颜色', value: ColorPicker.Default),
      ],
      title: '方式',
    );
    if (selector == null) return;
    Color? choiceColor;
    switch (selector) {
      case ColorPicker.Choice:
        choiceColor = await selectColorFromBoard(context);
        break;
      case ColorPicker.Input:
        choiceColor = await selectColorByRGB(context);
        break;
      case ColorPicker.Default:
        choiceColor = await selectColorFromMaterialPicker(context);
        break;
    }
    if (choiceColor == null) return;
    store.palette.add(choiceColor);
  }
}
