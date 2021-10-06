import 'package:blue_demo/data/database/database.dart';
import 'package:blue_demo/data/proto/gen/task.pbserver.dart';
import 'package:blue_demo/ui/components/color_selector.dart';
import 'package:blue_demo/ui/components/select_tile.dart';
import 'package:blue_demo/ui/page/task/store/task_maker_store.dart';
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          store.loop.add(LoopTask(colorList: RxList<Color>(), loop: RxInt(0)));
          store.editIndex.value = store.loop.length - 1;
        },
        child: const Icon(Icons.add),
      ),
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
              .map((key, loopE) {
                return MapEntry(
                  key,
                  Card(
                    child: Obx(() {
                      return Container(
                        color: key == store.editIndex.value
                            ? Colors.grey[200]
                            : null,
                        child: InkWell(
                          onTap: () {
                            store.editIndex.value = key;
                          },
                          onLongPress: () {
                            store.loop.removeAt(key);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(5),
                            child: Column(
                              children: [
                                Text('循环 ${key + 1}'),
                                const SizedBox(height: 3),
                                SizedBox(
                                  height: 30,
                                  child: Obx(() {
                                    return ListView.separated(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: loopE.colorList.length,
                                      separatorBuilder:
                                          (BuildContext context, int index) {
                                        return const SizedBox(width: 10);
                                      },
                                      itemBuilder: (context, index) {
                                        return InkWell(
                                          onTap: () {
                                            if (key == store.editIndex.value) {
                                              loopE.colorList.removeAt(index);
                                            } else {
                                              store.editIndex.value = key;
                                            }
                                          },
                                          child: AspectRatio(
                                            aspectRatio: 1,
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: loopE.colorList[index],
                                                borderRadius:
                                                    const BorderRadius.all(
                                                  Radius.circular(50),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    const Text('循环次数: '),
                                    SizedBox(
                                      width: 50,
                                      child: TextFormField(
                                        initialValue: '1',
                                        decoration: const InputDecoration(
                                          isDense: true,
                                        ),
                                        keyboardType: TextInputType.number,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly
                                        ],
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                );
              })
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
            padding: const EdgeInsets.only(
              top: 5,
              right: 5,
              left: 5,
              bottom: 10,
            ),
            child: Column(
              children: [
                const Text('调色板'),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: Obx(() {
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
                              store.loop[store.editIndex.value].colorList
                                  .add(color);
                            }
                          },
                          child: AspectRatio(
                            aspectRatio: 1,
                            child: Container(
                              decoration: BoxDecoration(
                                color: store.palette[index],
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(50)),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
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
