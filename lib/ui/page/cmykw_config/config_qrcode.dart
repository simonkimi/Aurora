import 'dart:convert';

import 'package:blue_demo/data/database/entity/config_entity.dart';
import 'package:blue_demo/data/proto/gen/config.pbserver.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ConfigQrCode extends StatelessWidget {
  const ConfigQrCode({
    Key? key,
    required this.entity,
  }) : super(key: key);

  final ConfigEntity entity;

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
        kc: entity.Kc);

    final buffer = base64Encode(pb.writeToBuffer());

    final size = MediaQuery.of(context).size.width;

    return SizedBox(
      width: size / 2,
      height: size / 2,
      child: Stack(
        children: [
          QrImage(
            data: buffer,
            version: QrVersions.auto,
            size: size,
            gapless: true,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: size / 12,
              height: size / 12,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset('assets/img/logo.png'),
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
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
