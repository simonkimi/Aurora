import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/page/ble_connect/hex_player.dart';
import 'package:aurora/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class BleHistory extends StatelessWidget {
  const BleHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '蓝牙历史', actions: [
        Observer(builder: (context) {
          return IconButton(
            onPressed: () {
              bluetoothStore.isSend = !bluetoothStore.isSend;
            },
            icon: Icon(bluetoothStore.isSend
                ? Icons.call_made_outlined
                : Icons.call_received),
          );
        }),
      ]),
      body: Observer(
        builder: (_) {
          return ListView(
            children: (bluetoothStore.isSend
                    ? bluetoothStore.sendHistory
                    : bluetoothStore.receiveHistory)
                .reversed
                .map((e) {
              return Card(
                child: ListTile(
                  title: Text(e.time.toString()),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        to16String(e.data),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text('length: ${e.data.length}'),
                    ],
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => HexPlayer(data: e.data)));
                  },
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
