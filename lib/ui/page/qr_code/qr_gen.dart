import 'package:aurora/ui/components/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QrGen extends StatelessWidget {
  const QrGen({
    Key? key,
    required this.buffer,
  }) : super(key: key);

  final String buffer;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '分享'),
      body: Center(
        child: buildQrCode(context),
      ),
    );
  }

  Widget buildQrCode(BuildContext context) {
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
}
