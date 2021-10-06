import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:blue_demo/data/database/database.dart';
import 'package:blue_demo/data/proto/gen/config.pbserver.dart';
import 'package:blue_demo/ui/page/cmykw_config/config_maker.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';

class ConfigScanner extends StatefulWidget {
  const ConfigScanner({Key? key}) : super(key: key);

  @override
  _ConfigScannerState createState() => _ConfigScannerState();
}

class _ConfigScannerState extends State<ConfigScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late final StreamSubscription<Barcode> listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: Stack(
        children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: FittedBox(
              child: Lottie.asset('assets/lottie/scanner.json'),
              fit: BoxFit.fill,
            ),
          )
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    listener = controller.scannedDataStream
        .debounceTime(const Duration(seconds: 2))
        .listen((scanData) {
      final scan = scanData.code;
      try {
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
        listener.cancel();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => ConfigMaker(
                  entity: entity,
                )));
      } catch (e) {
        BotToast.showText(text: '二维码解析失败!');
      }
    });
  }

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller.pauseCamera();
    } else if (Platform.isIOS) {
      controller.resumeCamera();
    }
  }


  @override
  void dispose() {
    super.dispose();
    controller.dispose();
    listener.cancel();
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '扫描分享',
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
