import 'package:aurora/data/store/main_store.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/color_selector.dart';
import 'package:aurora/ui/page/ble_connect/ble_scanner.dart';
import 'package:aurora/utils/get_cmykw.dart';
import 'package:aurora/utils/utils.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

enum AppBarAction {
  CMYKWConfig,
  SendHistory,
  AuroraVersion,
  HslGradient,
}

class ControllerPage extends StatefulWidget {
  const ControllerPage({Key? key}) : super(key: key);

  @override
  _ControllerPageState createState() => _ControllerPageState();
}

class _ControllerPageState extends State<ControllerPage>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  var auroraState = '停机';

  late AnimationController _actionController;

  @override
  void dispose() {
    _actionController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _actionController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
  }

  @override
  // ignore: must_call_super
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '控制', displayBack: false, actions: [
        PopupMenuButton<AppBarAction>(
          icon: const Icon(
            Icons.more_vert_outlined,
            color: Colors.white,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          onSelected: (value) async {
            switch (value) {
              case AppBarAction.CMYKWConfig:
                Navigator.of(context).pushNamed('/config');
                break;
              case AppBarAction.SendHistory:
                Navigator.of(context).pushNamed('/history');
                break;
              case AppBarAction.AuroraVersion:
                if (mainStore.version == MessageVersion.V1)
                  mainStore.version = MessageVersion.V3;
                else
                  mainStore.version = MessageVersion.V1;
                break;
              case AppBarAction.HslGradient:
                Navigator.of(context).pushNamed('/hsl');
                break;
            }
          },
          itemBuilder: (context) {
            return [
              buildPopupMenuItem(
                context: context,
                icon: Icons.stacked_line_chart,
                value: AppBarAction.CMYKWConfig,
                text: '耗材配置',
              ),
              buildPopupMenuItem(
                context: context,
                icon: Icons.history,
                value: AppBarAction.SendHistory,
                text: '发送历史',
              ),
              buildPopupMenuItem(
                context: context,
                icon: Icons.alt_route,
                value: AppBarAction.AuroraVersion,
                text: '切换版本',
              ),
              buildPopupMenuItem(
                context: context,
                icon: Icons.color_lens_outlined,
                value: AppBarAction.HslGradient,
                text: '渐变色',
              ),
            ];
          },
        ),
      ]),
      body: Observer(builder: (_) => buildBody()),
      floatingActionButton: buildFloatingActionButton(context),
    );
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
              Container(height: 230, color: Colors.blue),
              buildTopMessage(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [const SizedBox(height: 130), buildRGBCMYGWCard()],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(
              '颜色选择',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: buildColorChoiceList(),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingActionButton(BuildContext context) {
    return Observer(
      builder: (_) {
        if (bluetoothStore.connectedDevice != null) {
          return buildActionFab(context);
        }
        return buildSearchFab();
      },
    );
  }

  StreamBuilder<bool> buildSearchFab() {
    return StreamBuilder<bool>(
      stream: FlutterBlue.instance.isScanning,
      initialData: false,
      builder: (_, snapshot) {
        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(child: child, scale: animation);
          },
          child: snapshot.data!
              ? FloatingActionButton(
                  key: const ValueKey('stop'),
                  onPressed: FlutterBlue.instance.stopScan,
                  backgroundColor: Colors.red,
                  child: const SizedBox(
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
                  key: const ValueKey('scan'),
                  child: const Icon(Icons.search),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const BleScanner()));
                  },
                ),
        );
      },
    );
  }

  Widget buildActionFab(BuildContext context) {
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
      animatedIconData: AnimatedIcons.menu_close,
      items: [
        Bubble(
          title: '送料',
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.input,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            try {
              _actionController.reverse();
              await bluetoothStore.sendIn();
              setState(() {
                auroraState = '运行';
              });
              showMessage(context, '已发送');
            } on Exception catch (e) {
              showMessage(context, '出现错误: ${e.toString()}');
            }
          },
        ),
        Bubble(
          title: '退料',
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          icon: Icons.open_in_new,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            try {
              _actionController.reverse();
              await bluetoothStore.sendOut();
              setState(() {
                auroraState = '退料';
              });
              showMessage(context, '已发送');
            } on Exception catch (e) {
              showMessage(context, '出现错误: ${e.toString()}');
            }
          },
        ),
        Bubble(
          icon: Icons.stop,
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          title: '停止',
          onPress: () async {
            try {
              _actionController.reverse();
              await bluetoothStore.sendStop();
              setState(() {
                auroraState = '送料';
              });
              showMessage(context, '已发送');
            } on Exception catch (e) {
              showMessage(context, '出现错误: ${e.toString()}');
            }
          },
        ),
        Bubble(
          icon: Icons.widgets,
          title: '输入',
          iconColor: Colors.white,
          bubbleColor: Colors.blue,
          titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
          onPress: () async {
            try {
              _actionController.reverse();
              await showCmykwBuilder(context);
            } on Exception catch (e) {
              showMessage(context, '出现错误: ${e.toString()}');
            }
          },
        ),
      ],
    );
  }

  void showMessage(BuildContext context, String data) {
    BotToast.showText(text: data);
  }

  Future<void> showCmykwBuilder(BuildContext context) async {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final String? Function(String?) validator = (String? value) {
      final number = int.tryParse(value ?? '') ?? 0;
      if (0 <= number && number <= mainStore.cmykwConfig.ts) return null;
      return '数值错误';
    };

    final cController = TextEditingController()
      ..text = mainStore.cmykw.c.toString();
    final mController = TextEditingController()
      ..text = mainStore.cmykw.m.toString();
    final yController = TextEditingController()
      ..text = mainStore.cmykw.y.toString();
    final kController = TextEditingController()
      ..text = mainStore.cmykw.k.toString();
    final wController = TextEditingController()
      ..text = mainStore.cmykw.w.toString();

    final CMYKW? result = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('手动输入'),
            content: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: ListBody(
                  children: [
                    TextFormField(
                      controller: cController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'C',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: mController,
                      decoration: const InputDecoration(
                        labelText: 'M',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: yController,
                      decoration: const InputDecoration(
                        labelText: 'Y',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: kController,
                      decoration: const InputDecoration(
                        labelText: 'K',
                      ),
                      validator: validator,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                      ],
                    ),
                    TextFormField(
                      controller: wController,
                      decoration: const InputDecoration(
                        labelText: 'W',
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
                  if (_formKey.currentState!.validate()) {
                    Navigator.of(context).pop(CMYKW(
                      c: int.tryParse(cController.text) ?? 0,
                      m: int.tryParse(mController.text) ?? 0,
                      y: int.tryParse(yController.text) ?? 0,
                      k: int.tryParse(kController.text) ?? 0,
                      w: int.tryParse(wController.text) ?? 0,
                    ));
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
    if (result != null) {
      await bluetoothStore.sendCmykw(result);
      showMessage(context, '已发送');
    }
  }

  Widget buildColorChoiceList() {
    return Container(
        padding: const EdgeInsets.all(5),
        color: Colors.white,
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.pageview_outlined),
                ),
                title: const Text('自选颜色'),
                subtitle: const Text('从调色板中选择一个颜色'),
                onTap: () async {
                  final color = await selectColorFromBoard(
                      context, mainStore.selectColor);
                  if (color != null) {
                    mainStore.setColor(color);
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.color_lens_outlined),
                ),
                title: const Text('精确颜色'),
                subtitle: const Text('填入颜色RGB精确生成颜色'),
                onTap: () async {
                  final color =
                      await selectColorByRGB(context, mainStore.selectColor);
                  print(color);
                  if (color != null) {
                    mainStore.setColor(color);
                  }
                },
              ),
            ),
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.check),
                ),
                title: const Text('预设颜色'),
                subtitle: const Text('选择一个系统预设的颜色'),
                onTap: () async {
                  final color = await selectColorFromMaterialPicker(
                      context, mainStore.selectColor);
                  if (color != null) {
                    mainStore.setColor(color);
                  }
                },
              ),
            ),
          ],
        ));
  }

  Widget buildRGBCMYGWCard() {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                buildColorCard(
                    title: 'R',
                    value: mainStore.selectColor.red.toString(),
                    color: Colors.red),
                buildColorCard(
                    title: 'G',
                    value: mainStore.selectColor.green.toString(),
                    color: Colors.green),
                buildColorCard(
                    title: 'B',
                    value: mainStore.selectColor.blue.toString(),
                    color: Colors.blue),
              ],
            ),
            Row(
              children: [
                buildColorCard(
                  title: 'C',
                  value: mainStore.cmykw.c.toString(),
                  color: const Color(0xff22f5ff),
                  subtitle: mainStore.cmykw.c.toP(),
                ),
                buildColorCard(
                  title: 'M',
                  value: mainStore.cmykw.m.toString(),
                  color: const Color(0xffff2cd9),
                  subtitle: mainStore.cmykw.m.toP(),
                ),
                buildColorCard(
                  title: 'Y',
                  value: mainStore.cmykw.y.toString(),
                  color: const Color(0xffffff2c),
                  subtitle: mainStore.cmykw.y.toP(),
                ),
                buildColorCard(
                  title: 'K',
                  value: mainStore.cmykw.k.toString(),
                  color: const Color(0xff3a3a3a),
                  subtitle: mainStore.cmykw.k.toP(),
                ),
                buildColorCard(
                  title: 'W',
                  value: mainStore.cmykw.w.toString(),
                  color: const Color(0xff909399),
                  subtitle: mainStore.cmykw.w.toP(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Positioned buildTopMessage() {
    return Positioned(
      left: 45,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
              '当前设备 : ' +
                  (bluetoothStore.connectedDevice == null
                      ? '未连接'
                      : mainStore.version == MessageVersion.V3
                          ? 'Aurora V3'
                          : 'Aurora V1'),
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          Text('设备状态 : $auroraState',
              style: const TextStyle(color: Colors.white, fontSize: 16)),
          Row(
            children: [
              const Text(
                '设定颜色: ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  color: mainStore.selectColor,
                  width: 100,
                  child: const Text(''),
                ),
              )
            ],
          ),
          Row(
            children: [
              const Text(
                '当前颜色: ',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  color: mainStore.nowColor,
                  width: 100,
                  child: const Text(''),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget buildColorCard({
    required String title,
    required String value,
    required Color color,
    String? subtitle,
  }) {
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
              Text(value, style: TextStyle(color: color, fontSize: 15)),
              if (subtitle != null)
                Text(subtitle, style: TextStyle(color: color, fontSize: 10))
            ],
          ),
        ),
      ),
    );
  }

  PopupMenuItem<T> buildPopupMenuItem<T>({
    required BuildContext context,
    required IconData icon,
    required String text,
    required T value,
  }) {
    return PopupMenuItem<T>(
      value: value,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Theme.of(context).textTheme.subtitle1!.color,
          ),
          const SizedBox(width: 20),
          Text(text),
        ],
      ),
    );
  }
}
