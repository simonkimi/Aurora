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
      final entity = ConfigTableCompanion.insert(
        name: pb.name,
        ts: pb.ts,
        xy11: pb.xy11,
        xy12: pb.xy12,
        xy21: pb.xy21,
        xy22: pb.xy22,
        xy31: pb.xy31,
        xy32: pb.xy32,
        Kc: pb.kc,
        Kb2: pb.kb2,
        Kb1: pb.kb1,
        Ka: pb.ka,
        G_kw1: pb.gKw1,
        G_K_min: pb.gKMin,
        G_W_max: pb.gWMax,
        G_kwM: pb.gKwM,
      );
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ConfigMaker(
                entity: entity,
              )));
    }
  }

  void onGenQrPress(BuildContext context, ConfigTableData entity) {
    final pb = CMYKWConfigPB(
      xy32: entity.xy32,
      xy31: entity.xy31,
      xy22: entity.xy22,
      xy21: entity.xy21,
      xy12: entity.xy12,
      xy11: entity.xy11,
      ts: entity.ts,
      gKMin: entity.G_K_min,
      gKw1: entity.G_kw1,
      gKwM: entity.G_kwM,
      gWMax: entity.G_W_max,
      ka: entity.Ka,
      kb1: entity.Kb1,
      kb2: entity.Kb2,
      kc: entity.Kc,
      name: entity.name,
    );
    final buffer = base64Encode(pb.writeToBuffer());
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => QrGen(buffer: buffer)));
  }

  ListView buildList(BuildContext context,
      AsyncSnapshot<List<ConfigTableData>> snapshot, StateSetter setState) {
    mainStore.cmykwConfig;
    return ListView(
      children: snapshot.data!.map((e) {
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
                    mainStore.setCmykwConfig(e);
                    break;
                  case ConfigItemAction.EDIT:
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) =>
                            ConfigMaker(entity: e.toCompanion(true))));
                    break;
                  case ConfigItemAction.SHARE:
                    onGenQrPress(context, e);
                    break;
                  case ConfigItemAction.DELETE:
                    if (snapshot.data!.length == 1) {
                      BotToast.showText(text: '请至少保留一个配置');
                      return;
                    }
                    print('删除配置');
                    await DB().configDao.deleteConfig(e.name);
                    setState(() {});
                    break;
                }
              }
            },
            onTap: () {
              mainStore.setCmykwConfig(e);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        e.name,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 150),
                        child: mainStore.cmykwConfig.isSame(e)
                            ? Container(
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                ),
                                decoration: const BoxDecoration(
                                  color: Colors.green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50)),
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
                                  Text('最灰色值: ${e.G_kwM}'),
                                  Text('最黑色值: ${e.G_K_min}'),
                                  Text('拟合参数a: ${e.Ka}'),
                                  Text('拟合参数b2: ${e.Kb2}'),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('最白色值: ${e.G_W_max}'),
                                  Text('黑阶分界值: ${e.G_kw1}'),
                                  Text('拟合参数b1: ${e.Kb1}'),
                                  Text('拟合参数c: ${e.Kc}'),
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
                                  Text('${e.xy11}, '),
                                  Text('${e.xy21}, '),
                                  Text('${e.xy31}, '),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(e.xy12.toString()),
                                  Text(e.xy22.toString()),
                                  Text(e.xy32.toString()),
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
            ),
          ),
        );
      }).toList(),
    );
  }
}
