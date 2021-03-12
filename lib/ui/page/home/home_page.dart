import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:like_button/like_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_store.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: buildFloatingActionButton(),
      body: buildBody(),
    );
  }

  FloatingActionButton buildFloatingActionButton() {
    return FloatingActionButton(
      child: Icon(Icons.send),
      onPressed: () {},
    );
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
        Observer(
          builder: (_) {
            return Padding(
              padding: const EdgeInsets.only(right: 16),
              child: homeStore.isScanning
                  ? Center(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 5),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            strokeWidth: 2.2,
                          ),
                        ),
                      ),
                    )
                  : LikeButton(
                      padding: EdgeInsets.zero,
                      size: 24,
                      circleColor: CircleColor(
                          start: Color(0xff00ddff), end: Color(0xff0099cc)),
                      bubblesColor: BubblesColor(
                        dotPrimaryColor: Colors.white,
                        dotSecondaryColor: Colors.white,
                      ),
                      isLiked: homeStore.isConnect,
                      onTap: (value) async {
                        return homeStore.connectDevice();
                      },
                      likeBuilder: (bool isLink) {
                        return Icon(
                          isLink ? Icons.bluetooth : Icons.block,
                          color: Colors.white,
                          size: 24,
                        );
                      },
                    ),
            );
          },
        ),
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
              num.toString(),
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
                value: '0000 → 0000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFFFFF2C),
                leading: 'Front Motor 2:',
                value: '0000 → 0000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFFF2CD9),
                leading: 'Front Motor 3:',
                value: '0000 → 0000',
              ),
              SizedBox(height: 10),
              buildMotorItem(
                  background: Color(0XFF3A3A3A),
                  leading: 'Back Motor 1:',
                  value: '0000 → 0000',
                  color: Colors.white),
              SizedBox(height: 10),
              buildMotorItem(
                background: Color(0XFFEFF3FF),
                leading: 'Back Motor 2:',
                value: '0000 → 0000',
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
        buildCmyk(Color(0XFF22F5FF), 0, Colors.black),
        buildCmyk(Color(0XFFFFFF2C), 0, Colors.black),
        buildCmyk(Color(0XFFFF2CD9), 0, Colors.black),
        buildCmyk(Color(0XFF3A3A3A), 0, Colors.white),
        buildCmyk(Color(0XFFEFF3FF), 0, Colors.black),
      ],
    );
  }

  Row buildColorRow() {
    return Row(
      children: [
        buildColorCard(Color(0XFFFF4615), 'R', homeStore.selectColor?.red ?? 0),
        buildColorCard(
            Color(0XFF00D648), 'G', homeStore.selectColor?.green ?? 0),
        buildColorCard(
            Color(0XFF158cFF), 'B', homeStore.selectColor?.blue ?? 0),
      ],
    );
  }

  Expanded buildColorCircle() {
    return Expanded(
      child: Center(
        child: Center(
          child: CircleColorPicker(
            initialColor: homeStore.selectColor,
            onChanged: (color) async {
              final pref = await SharedPreferences.getInstance();
              pref.setInt('color', color.value);
              homeStore.setColor(color);
            },
            size: const Size(300, 300),
            strokeWidth: 4,
            thumbSize: 36,
          ),
        ),
      ),
    );
  }
}
