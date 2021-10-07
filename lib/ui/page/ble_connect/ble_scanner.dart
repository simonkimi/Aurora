import 'package:aurora/ui/components/app_bar.dart';
import 'package:flutter/material.dart';


class BleScanner extends StatelessWidget {
  const BleScanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '蓝牙扫描'),
    );
  }
}
