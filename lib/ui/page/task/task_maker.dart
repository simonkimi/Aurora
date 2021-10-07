import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/proto/gen/task.pbserver.dart';
import 'package:aurora/ui/components/color_selector.dart';
import 'package:aurora/ui/components/select_tile.dart';
import 'package:aurora/ui/page/task/store/task_maker_store.dart';
import 'package:aurora/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

enum ColorPicker { Choice, Input, Default }

class TaskMaker extends StatelessWidget {
  TaskMaker({Key? key, TaskTableData? tableData})
      : store = TaskMakerStore(
            tableData != null ? TaskPb.fromBuffer(tableData.taskPb) : null),
        super(key: key);

  final TaskMakerStore store;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
      floatingActionButton: buildFloatingActionButton(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      onPressed: () {
        store.loop.add(LoopTask(colorList: RxList<Color>(), loop: RxInt(1)));
        store.editIndex.value = store.loop.length - 1;
      },
      child: const Icon(Icons.add),
    );
  }

  Column buildBody() {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        buildPalette(),
        buildLoopList(),
      ],
    );
  }

  Expanded buildLoopList() {
    return Expanded(
      child: Obx(() {
        return ListView(
          children: store.loop
              .asMap()
              .map((key, value) => MapEntry(key, buildLoopCard(key, value)))
              .values
              .toList(),
        );
      }),
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
    return Card(
      child: Obx(() {
        return Container(
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
      }),
    );
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
      itemCount: store.palette.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          width: 10,
        );
      },
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            if (store.loop.isNotEmpty) {
              final color = store.palette[index];
              store.loop[store.editIndex.value].colorList.add(color);
            }
          },
          onLongPress: () {
            store.palette.removeAt(index);
          },
          child: AspectRatio(
            aspectRatio: 1,
            child: Container(
              decoration: BoxDecoration(
                color: store.palette[index],
                borderRadius: const BorderRadius.all(Radius.circular(50)),
              ),
            ),
          ),
        );
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('新建任务', style: TextStyle(fontSize: 18)),
      centerTitle: true,
      automaticallyImplyLeading: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      actions: [
        IconButton(
          onPressed: () {
            showColorTile(context);
          },
          icon: const Icon(Icons.color_lens_outlined),
        ),
        IconButton(
          onPressed: () {
            if (store.loop.isNotEmpty) {
              final pb = store.transformToPb();
              Navigator.of(context).pop(pb);
            }
          },
          icon: const Icon(Icons.check),
        ),
      ],
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