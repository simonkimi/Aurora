import 'package:animated_float_action_button/animated_floating_action_button.dart';
import 'package:blue_demo/ui/data/store/main_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:blue_demo/utils/utils.dart';

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key key}) : super(key: key);

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage> {
  var _currentColor = mainStore.selectColor;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var auroraState = '停机';
  var motorState = '送料';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Observer(builder: (_) => buildBody()),
      floatingActionButton: buildFloatingActionButton(context),
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
                  setState(() {
                    auroraState = '运行';
                  });
                  showMessage(context, '已发送');
                } on Exception catch (e) {
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
                  setState(() {
                    auroraState = '停止';
                  });
                  showMessage(context, '已发送');
                } on Exception catch (e) {
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
                  setState(() {
                    auroraState = '送料';
                  });
                  showMessage(context, '已发送');
                } on Exception catch (e) {
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
                  setState(() {
                    auroraState = '回抽';
                  });
                  showMessage(context, '已发送');
                } on Exception catch (e) {
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
                } on Exception catch (e) {
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
    return Container(
      color: Colors.grey[200],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                height: 200,
                color: Colors.blue,
              ),
              Positioned(
                left: 45,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '当前设备 : ' +
                            (mainStore.connectedDevice != null
                                ? "Aurora"
                                : "未连接"),
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('设备状态 : $auroraState',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Text('出料状态 : $motorState',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    Row(
                      children: [
                        Text(
                          '设定颜色: ',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Container(
                            color: mainStore.selectColor,
                            width: 100,
                            child: Text(''),
                          ),
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
                          child: Container(
                            color: mainStore.selectColor,
                            width: 100,
                            child: Text(''),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 30,
                bottom: -40,
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  width: 350,
                  height: 120,
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          buildColorCard(
                              'R',
                              mainStore.selectColor?.red?.toString() ?? '0',
                              Colors.red),
                          buildColorCard(
                              'G',
                              mainStore.selectColor?.green.toString() ?? '0',
                              Colors.green),
                          buildColorCard(
                              'B',
                              mainStore.selectColor?.blue.toString() ?? '0',
                              Colors.blue),
                        ],
                      ),
                      Row(
                        children: [
                          buildColorCard(
                              'C', mainStore.cmykw.c.toP(), Color(0XFF22F5FF)),
                          buildColorCard(
                              'Y', mainStore.cmykw.y.toP(), Color(0XFFFF2CD9)),
                          buildColorCard(
                              'M', mainStore.cmykw.m.toP(), Color(0XFFFFFF2C)),
                          buildColorCard(
                              'K', mainStore.cmykw.k.toP(), Color(0XFF3A3A3A)),
                          buildColorCard(
                              'W', mainStore.cmykw.w.toP(), Color(0XFF909399)),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 40),
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
                        onTap: selectColorFromBoard,
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
                        onTap: selectColorByRGB,
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
                        onTap: selectColorFromMaterialPicker,
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

  void selectColorFromBoard() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择一个颜色'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: Color(mainStore.selectColor.value | 0xFF000000),
              onColorChanged: (v) {
                setState(() {
                  _currentColor = v;
                });
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
                mainStore.setColor(_currentColor);
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

  void selectColorFromMaterialPicker() async {
    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('选择一个颜色'),
          content: SingleChildScrollView(
            child: MaterialPicker(
              pickerColor: Color(mainStore.selectColor.value | 0xFF000000),
              onColorChanged: (v) {
                setState(() {
                  _currentColor = v;
                });
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
                mainStore.setColor(_currentColor);
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

  void selectColorByRGB() {
    final validator = (String value) =>
        0 <= int.tryParse(value) && int.tryParse(value) <= 255 ? null : '资源错误';

    final rController = TextEditingController();
    final gController = TextEditingController();
    final bController = TextEditingController();

    rController.text = mainStore.selectColor.red.toString();
    gController.text = mainStore.selectColor.green.toString();
    bController.text = mainStore.selectColor.blue.toString();

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
                    setState(() {
                      mainStore.setColor(Color.fromARGB(
                          0,
                          int.parse(rController.value.text),
                          int.parse(gController.value.text),
                          int.parse(bController.value.text)));
                    });
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
