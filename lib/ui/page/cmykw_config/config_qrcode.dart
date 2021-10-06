import 'dart:convert';

import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/proto/gen/config.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConfigQrCode extends StatelessWidget {
  const ConfigQrCode({
    Key? key,
    required this.entity,
  }) : super(key: key);

  final ConfigTableData entity;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          Center(
            child: qrCode(context),
          ),
        ],
      ),
    );
  }

  Widget qrCode(BuildContext context) {
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

    final size = MediaQuery.of(context).size.width;

    return QrImage(
      data: buffer,
      size: size / 2,
      gapless: true,
      embeddedImage: const AssetImage('assets/img/logo_round.png'),
      embeddedImageStyle: QrEmbeddedImageStyle(
        size: Size(size / 10, size / 10),
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '分享',
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
}
