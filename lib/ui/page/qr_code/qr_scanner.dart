import 'dart:async';
import 'dart:io';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QrScanner extends StatefulWidget {
  const QrScanner({Key? key}) : super(key: key);

  @override
  _QrScannerState createState() => _QrScannerState();
}

class _QrScannerState extends State<QrScanner> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  late QRViewController controller;
  late final StreamSubscription<Barcode> listener;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '扫描分享'),
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
        .listen((scanData) {
      print('扫描到二维码: ${scanData.code.length}');
      listener.cancel();
      Navigator.of(context).pop(scanData.code);
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
    controller.dispose();
    listener.cancel();
    super.dispose();
  }
}
