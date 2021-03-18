import 'package:blue_demo/data/controller/global_binding.dart';
import 'package:blue_demo/ui/page/main/main_page.dart';
import 'package:blue_demo/ui/page/state/state_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'data/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper().init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
      initialRoute: '/',
      initialBinding: GlobalBinding(),
      routes: {
        '/': (context) => MainPage(),
      },
    );
  }
}
