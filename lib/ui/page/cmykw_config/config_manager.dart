import 'package:blue_demo/data/database/database_helper.dart';
import 'package:blue_demo/data/database/entity/config_entity.dart';
import 'package:blue_demo/main.dart';
import 'package:blue_demo/ui/components/select_tile.dart';
import 'package:blue_demo/ui/page/cmykw_config/config_maker.dart';
import 'package:blue_demo/ui/page/cmykw_config/config_qrcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

enum ConfigItemAction { USE, EDIT, SHARE, DELETE }

class ConfigManager extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
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

  StreamBuilder<List<ConfigEntity>> buildBody() {
    return StreamBuilder<List<ConfigEntity>>(
      stream: DB().configDao.getAllStream(),
      initialData: const [],
      builder: (context, snapshot) {
        return Observer(builder: (_) => buildList(context, snapshot));
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '耗材配置',
        style: TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }

  ListView buildList(
      BuildContext context, AsyncSnapshot<List<ConfigEntity>> snapshot) {
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
                        builder: (context) => ConfigMaker(entity: e)));
                    break;
                  case ConfigItemAction.SHARE:
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ConfigQrCode(entity: e)));
                    break;
                  case ConfigItemAction.DELETE:
                    await DB().configDao.deleteConfig(e);
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
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: Column(
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
                      )
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
