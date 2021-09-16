import 'package:flutter/material.dart';

class ConfigManager extends StatefulWidget {
  const ConfigManager({Key? key}) : super(key: key);

  @override
  _ConfigManagerState createState() => _ConfigManagerState();
}

class _ConfigManagerState extends State<ConfigManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
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
        icon: const Icon(Icons.arrow_back_ios),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
