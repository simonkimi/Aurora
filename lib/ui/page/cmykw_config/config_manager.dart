import 'dart:convert';

import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/database/database_helper.dart';
import 'package:aurora/data/proto/gen/config.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/select_tile.dart';
import 'package:aurora/ui/page/cmykw_config/config_maker.dart';
import 'package:aurora/ui/page/qr_code/qr_gen.dart';
import 'package:aurora/ui/page/qr_code/qr_scanner.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

enum ConfigItemAction { USE, EDIT, SHARE, DELETE }

class ConfigManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '耗材配置', actions: [
        IconButton(
          onPressed: () => onScanPress(context),
          icon: const Icon(Icons.qr_code),
        ),
      ]),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => ConfigMaker()));
        },
        child: const Icon(Icons.add),
      ),
      body: buildBody(),
    );
  }

  Widget buildBody() {
    return StatefulBuilder(builder: (context, setState) {
      return StreamBuilder<List<ConfigTableData>>(
        stream: DB().configDao.getAllStream(),
        initialData: const [],
        builder: (context, snapshot) {
          return Observer(
              builder: (_) => buildList(context, snapshot, setState));
        },
      );
    });
  }

  Future<void> onScanPress(BuildContext context) async {
    final scan = await Navigator.of(context).push<String?>(
        MaterialPageRoute(builder: (context) => const QrScanner()));
    if (scan != null) {
      final pb = CMYKWConfigPB.fromBuffer(base64Decode(scan));
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfigMaker(
                entity: pb,
              )));
    }
  }

  void onGenQrPress(BuildContext context, CMYKWConfigPB pb) {
    final buffer = base64Encode(pb.writeToBuffer());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QrGen(buffer: buffer)));
  }

  ListView buildList(BuildContext context,
      AsyncSnapshot<List<ConfigTableData>> snapshot, StateSetter setState) {
    mainStore.cmykwConfig;
    return ListView(
      children: snapshot.data!.map((e) {
        final pb = CMYKWConfigPB.fromBuffer(e.pb);
        return Card(
          child: InkWell(
            onLongPress: () async {
              final dialog = await showSelectDialog<ConfigItemAction>(
                context: context,
                items: const [
                  SelectTileItem(title: '使用', value: ConfigItemAction.USE),
                  SelectTileItem(title: '编辑', value: ConfigItemAction.EDIT),
                  SelectTileItem(title: '分享', value: ConfigItemAction.SHARE),
                  SelectTileItem(title: '删除', value: ConfigItemAction.DELETE),
                ],
                title: '菜单',
                displayRadio: false,
              );
              if (dialog != null) {
                switch (dialog) {
                  case ConfigItemAction.USE:
                    mainStore.setCmykwConfig(pb);
                    break;
                  case ConfigItemAction.EDIT:
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfigMaker(entity: pb)));
                    break;
                  case ConfigItemAction.SHARE:
                    onGenQrPress(context, pb);
                    break;
                  case ConfigItemAction.DELETE:
                    if (snapshot.data!.length == 1) {
                      BotToast.showText(text: '请至少保留一个配置');
                      return;
                    }
                    await DB().configDao.remove(e);
                    if (mainStore.cmykwConfig.name == e.name) {
                      mainStore.cmykwConfig = CMYKWConfigPB.fromBuffer(
                          (await DB().configDao.getAll()).first.pb);
                    }
                    setState(() {});
                    break;
                }
              }
            },
            onTap: () {
              mainStore.setCmykwConfig(pb);
            },
            child: buildCard(pb),
          ),
        );
      }).toList(),
    );
  }

  Widget buildCard(CMYKWConfigPB pb) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                pb.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: mainStore.cmykwConfig == pb
                    ? Container(
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      )
                    : const SizedBox(),
              )
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('转速基准: ${pb.ts}'),
                          Text('最灰色值: ${pb.gKwM}'),
                          Text('最黑色值: ${pb.gKMin}'),
                          Text('拟合参数a: ${pb.ka}'),
                          Text('拟合参数b2: ${pb.kb2}'),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('测试平台: ${pb.platformSpeed}'),
                          Text('最白色值: ${pb.gWMax}'),
                          Text('黑阶分界值: ${pb.gKw1}'),
                          Text('拟合参数b1: ${pb.kb1}'),
                          Text('拟合参数c: ${pb.kc}'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Column(
                children: [
                  const Text('颜色配置矩阵'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text('${pb.xy11}, '),
                          Text('${pb.xy21}, '),
                          Text('${pb.xy31}, '),
                        ],
                      ),
                      Column(
                        children: [
                          Text(pb.xy12.toString()),
                          Text(pb.xy22.toString()),
                          Text(pb.xy32.toString()),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}
