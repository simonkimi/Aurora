import 'package:blue_demo/data/controller/global_controller.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:blue_demo/utils/utils.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';

import 'controller_controller.dart';

class ControllerPage extends HookWidget {
  ControllerPage({Key key}): super(key: key);



  final global = Get.find<GlobalController>();
  final controller = Get.put(ControllerController());
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final _actionController =
    useAnimationController(duration: Duration(milliseconds: 260));
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(context),
      floatingActionButton: Obx(() => buildFloatingActionButton(context, _actionController)),
    );
  }

  Widget buildFloatingActionButton(BuildContext context, _actionController) {
    if (global.connectedDevice.value != null) {
      return FloatingActionBubble(
        animation: _actionController,
        onPress: () {
          if (_actionController.isCompleted) {
            _actionController.reverse();
          } else {
            _actionController.forward();
          }
        },
        iconColor: Colors.blue,
        icon: AnimatedIcons.menu_close,
        items: [
          Bubble(
            title: "开始",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.play_arrow,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              try {
                _actionController.reverse();
                await global.sendStart();
                controller.auroraState = '运行';
                showMessage(context, '已发送');
              } on Exception catch (e) {
                showMessage(context, '出现错误: ${e.toString()}');
              }
            },
          ),
          Bubble(
            title: "暂停",
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            icon: Icons.pause,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              try {
                _actionController.reverse();
                await global.sendPause();
                controller.auroraState = '停止';
                showMessage(context, '已发送');
              } on Exception catch (e) {
                showMessage(context, '出现错误: ${e.toString()}');
              }
            },
          ),
          Bubble(
            icon: Icons.input,
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            title: '送料',
            onPress: () async {
              try {
                _actionController.reverse();
                await global.sendPush();
                controller.auroraState = '送料';
                showMessage(context, '已发送');
              } on Exception catch (e) {
                showMessage(context, '出现错误: ${e.toString()}');
              }
            },
          ),
          Bubble(
            icon: Icons.open_in_new,
            title: '回抽',
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              try {
                _actionController.reverse();
                await global.sendPop();
                controller.auroraState = '回抽';
                showMessage(context, '已发送');
              } on Exception catch (e) {
                showMessage(context, '出现错误: ${e.toString()}');
              }
            },
          ),
          Bubble(
            icon: Icons.send,
            title: '发送',
            iconColor: Colors.white,
            bubbleColor: Colors.blue,
            titleStyle: TextStyle(fontSize: 16, color: Colors.white),
            onPress: () async {
              try {
                _actionController.reverse();
                await global.sendColor();
                showMessage(context, '已发送');
              } on Exception catch (e) {
                showMessage(context, '出现错误: ${e.toString()}');
              }
            },
          ),
        ],
      );

      //   ],
      // );
    }
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (_, snapshot) {
        return AnimatedSwitcher(
          duration: Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: snapshot.data
              ? FloatingActionButton(
                  key: ValueKey('stop'),
                  onPressed: FlutterBlue.instance.stopScan,
                  backgroundColor: Colors.red,
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.red,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                      strokeWidth: 3,
                    ),
                  ),
                )
              : FloatingActionButton(
                  key: ValueKey('scan'),
                  child: const Icon(Icons.search),
                  onPressed: () {
                    global.findAndConnect();
                  },
                ),
        );
      },
    );
  }

  void showMessage(BuildContext context, String data) {
    BotToast.showText(text: data, duration: Duration(milliseconds: 500));
  }

  Widget buildBody(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 230,
                color: Colors.blue,
              ),
              Positioned(
                left: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                        '当前设备 : ' +
                            (global.connectedDevice.value != null ? "Aurora" : "未连接"),
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                    Obx(() => Text('设备状态 : ${controller.auroraState}',
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                    Obx(() => Text('出料状态 : ${controller.motorState}',
                        style: TextStyle(color: Colors.white, fontSize: 16))),
                    Row(
                      children: [
                        Text(
                          '设定颜色: ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Obx(() => Container(
                                color: global.selectColor.value,
                                width: 100,
                                child: Text(''),
                              )),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          '当前颜色: ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Obx(() => Container(
                                color: global.nowColor.value,
                                width: 100,
                                child: Text(''),
                              )),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 5,
                bottom: -45,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 400,
                  height: 120,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Obx(() => buildColorCard(
                              'R',
                              global.selectColor.value?.red?.toString() ?? '0',
                              Colors.red)),
                          Obx(() => buildColorCard(
                              'G',
                              global.selectColor.value?.green.toString() ?? '0',
                              Colors.green)),
                          Obx(() => buildColorCard(
                              'B',
                              global.selectColor.value?.blue.toString() ?? '0',
                              Colors.blue)),
                        ],
                      ),
                      Row(
                        children: [
                          Obx(() => buildColorCard('C',
                              global.cmykw.value.c.toP(), Color(0XFF22F5FF))),
                          Obx(() => buildColorCard('Y',
                              global.cmykw.value.y.toP(), Color(0XFFFF2CD9))),
                          Obx(() => buildColorCard('M',
                              global.cmykw.value.m.toP(), Color(0XFFFFFF2C))),
                          Obx(() => buildColorCard('K',
                              global.cmykw.value.k.toP(), Color(0XFF3A3A3A))),
                          Obx(() => buildColorCard('W',
                              global.cmykw.value.w.toP(), Color(0XFF909399))),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 50),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '颜色选择',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: Container(
                padding: EdgeInsets.all(5),
                color: Colors.white,
                child: ListView(
                  children: [
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.pageview_outlined),
                        ),
                        title: Text('自选颜色'),
                        subtitle: Text('从调色板中选择一个颜色'),
                        onTap: () {
                          selectColorFromBoard(context);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.color_lens_outlined),
                        ),
                        title: Text('精确颜色'),
                        subtitle: Text('填入颜色RGB精确生成颜色'),
                        onTap: () {
                          selectColorByRGB(context);
                        },
                      ),
                    ),
                    Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Icon(Icons.check),
                        ),
                        title: Text('预设颜色'),
                        subtitle: Text('选择一个系统预设的颜色'),
                        onTap: () {
                          selectColorFromMaterialPicker(context);
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  Widget buildColorCard(String title, String value, Color color) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                    color: color, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              Text(value, style: TextStyle(color: color, fontSize: 15))
            ],
          ),
        ),
      ),
    );
  }

  Widget buildAppBar() {
    return AppBar(
      title: Text(
        '控制',
        style: TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }

  void selectColorFromBoard(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择一个颜色'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(global.selectColor.value.value | 0xFF000000),
              onColorChanged: (v) {
                controller.currentColor = v;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
              enableAlpha: false,
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                global.setColor(controller.currentColor);
                Navigator.of(context).pop();
              },
              child: Text('确定'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void selectColorFromMaterialPicker(BuildContext context) async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择一个颜色'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Color(global.selectColor.value.value | 0xFF000000),
              onColorChanged: (v) {
                controller.currentColor = v;
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('取消'),
            ),
            TextButton(
              onPressed: () {
                global.setColor(controller.currentColor);
                Navigator.of(context).pop();
              },
              child: Text('确定'),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blue),
                  foregroundColor: MaterialStateProperty.all(Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void selectColorByRGB(BuildContext context) {
    final validator = (String value) {
      if (value.isEmpty) {
        return '请输入数值';
      }
      return 0 <= int.tryParse(value) && int.tryParse(value) <= 255
          ? null
          : '数值超出范围';
    };

    final rController = TextEditingController();
    final gController = TextEditingController();
    final bController = TextEditingController();

    rController.text = global.selectColor.value.red.toString();
    gController.text = global.selectColor.value.green.toString();
    bController.text = global.selectColor.value.blue.toString();

    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('设置颜色'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: [
                    TextFormField(
                      controller: rController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'R',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: gController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'G',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: bController,
                      decoration: const InputDecoration(
                        labelText: 'B',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('取消'),
              ),
              TextButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    global
                      .setColor(Color.fromARGB(
                        0xFF,
                        int.parse(rController.value.text),
                        int.parse(gController.value.text),
                        int.parse(bController.value.text),
                      ));
                    Navigator.of(context).pop();
                  }
                },
                child: const Text('确定'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor:
                      MaterialStateProperty.all(Theme.of(context).primaryColor),
                ),
              )
            ],
          );
        });
  }
}
