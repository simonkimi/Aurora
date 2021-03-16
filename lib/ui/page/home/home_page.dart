import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:blue_demo/ui/data/store/main_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:blue_demo/utils/utils.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(context),
      body: buildBody(),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return Observer(builder: (_) {
      if (mainStore.connectedDevice != null) {
        return AnimatedFloatingActionButton(
          animatedIconData: AnimatedIcons.menu_close,
          colorStartAnimation: Colors.blue,
          colorEndAnimation: Colors.red,
          fabButtons: [
            FloatActionButtonText(
              icon: Icons.play_arrow,
              text: 'Start',
              onPressed: () async {
                try {
                  await mainStore.sendStart();
                  showMessage(context, '已发送');
                } on Exception catch(e) {
                  showMessage(context, '出现错误: ${e.toString()}');
                }
              },
            ),
            FloatActionButtonText(
              icon: Icons.stop,
              text: 'Pause',
              onPressed: () async {
                try {
                  await mainStore.sendPause();
                  showMessage(context, '已发送');
                } on Exception catch(e) {
                  showMessage(context, '出现错误: ${e.toString()}');
                }
              },
            ),

            FloatActionButtonText(
              icon: Icons.input,
              text: 'Push',
              onPressed: () async {
                try {
                  await mainStore.sendPush();
                  showMessage(context, '已发送');
                } on Exception catch(e) {
                  showMessage(context, '出现错误: ${e.toString()}');
                }
              },
            ),
            FloatActionButtonText(
              icon: Icons.open_in_new,
              text: 'Pop',
              onPressed: () async {
                try {
                  await mainStore.sendPop();
                  showMessage(context, '已发送');
                } on Exception catch(e) {
                  showMessage(context, '出现错误: ${e.toString()}');
                }
              },
            ),
            FloatActionButtonText(
              icon: Icons.send,
              text: 'Send',
              onPressed: () async {
                try {
                  await mainStore.sendColor();
                  showMessage(context, '已发送');
                } on Exception catch(e) {
                  showMessage(context, '出现错误: ${e.toString()}');
                }
              },
            ),
          ],
        );
      }
      return FloatingActionButton(
        child: Icon(Icons.bluetooth_disabled_outlined),
        onPressed: () {
          Navigator.of(context).pushNamed('/search');
        },
      );
    });
  }

  void showMessage(BuildContext context, String data) {
    ScaffoldMessenger.of(context).removeCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(data),
      duration: Duration(seconds: 1),
    ));
  }

  Widget buildBody() {
    return Observer(builder: (_) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 10),
            buildMotorCard(),
            SizedBox(height: 50),
            buildCmykRow(),
            buildColorRow(),
            const SizedBox(height: 50),
            buildColorCircle()
          ],
        ),
      );
    });
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('Color Controller'),
      actions: [
        IconButton(icon: Icon(Icons.stop), onPressed: () {}),
      ],
    );
  }

  Widget buildCmyk(Color color, int num, Color textColor) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        child: Card(
          color: color,
          child: Center(
            child: Text(
              num.toP(),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: textColor,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildColorCard(Color color, String leading, int num) {
    return Expanded(
      flex: 1,
      child: Container(
        height: 40,
        child: Card(
          color: color,
          child: Center(
            child: Row(
              children: [
                SizedBox(
                  width: 10,
                ),
                Text(
                  leading,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  ':',
                  style: TextStyle(color: Colors.black, fontSize: 20),
                ),
                Expanded(
                  child: Text(
                    num.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildMotorCard() {
    return Container(
      child: Card(
        color: Color(0xFFEBEEF5),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Column(
            children: [
              Text(
                '转速',
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
              ),
              Text(
                '给定值 → 实际值',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 5),
              buildMotorItem(
                background: Color(0XFF22F5FF),
                leading: 'Front Motor 1:',
                value: '${mainStore.nowCmykw.c.to3()} → 000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFFF2CD9),
                leading: 'Front Motor 2:',
                value: '${mainStore.nowCmykw.y.to3()} → 000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFFFFF2C),
                leading: 'Front Motor 3:',
                value: '${mainStore.nowCmykw.m.to3()} → 000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                  background: Color(0XFF3A3A3A),
                  leading: 'Back Motor 1:',
                  value:
                      '${mainStore.nowCmykw.k.to3()} → 000',
                  color: Colors.white),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFEFF3FF),
                leading: 'Back Motor 2:',
                value: '${mainStore.nowCmykw.w.to3()} → 000',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Row buildMotorItem({
    Color background,
    String leading,
    String value,
    Color color = Colors.black,
  }) {
    return Row(
      children: [
        Text(
          leading,
          style: TextStyle(fontSize: 20),
        ),
        Expanded(
          child: SizedBox(
            width: double.infinity,
            child: Container(
              color: background,
              child: Text(
                value,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: color ?? Colors.black),
              ),
            ),
          ),
        )
      ],
    );
  }

  Row buildCmykRow() {
    return Row(
      children: [
        buildCmyk(Color(0XFF22F5FF), mainStore.cmykw.c, Colors.black),
        buildCmyk(Color(0XFFFFFF2C), mainStore.cmykw.y, Colors.black),
        buildCmyk(Color(0XFFFF2CD9), mainStore.cmykw.m, Colors.black),
        buildCmyk(Color(0XFF3A3A3A), mainStore.cmykw.k, Colors.white),
        buildCmyk(Color(0XFFEFF3FF), mainStore.cmykw.w, Colors.black),
      ],
    );
  }

  Row buildColorRow() {
    return Row(
      children: [
        buildColorCard(Color(0XFFFF4615), 'R', mainStore.selectColor?.red ?? 0),
        buildColorCard(
            Color(0XFF00D648), 'G', mainStore.selectColor?.green ?? 0),
        buildColorCard(
            Color(0XFF158cFF), 'B', mainStore.selectColor?.blue ?? 0),
      ],
    );
  }

  Expanded buildColorCircle() {
    return Expanded(
      child: ColorPicker(
        pickerColor: mainStore.selectColor,
        onColorChanged: mainStore.setColor,
        pickerAreaHeightPercent: 0.8,
        enableAlpha: false,
        displayThumbColor: true,
        showLabel: false,
        pickerAreaBorderRadius: BorderRadius.all(Radius.circular(5)),
      ),
    );
  }
}
