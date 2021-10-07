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
      appBar: buildAppBar(context),
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
