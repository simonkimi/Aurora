import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:rxdart/rxdart.dart';

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
