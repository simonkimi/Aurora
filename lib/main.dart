import 'package:blue_demo/ui/page/cmykw_config/config_manager.dart';
import 'package:blue_demo/ui/page/main/main_page.dart';
import 'package:blue_demo/ui/page/state/state_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

import 'data/database/database_helper.dart';
import 'data/store/main_store.dart';
import 'data/store/task_store.dart';

final mainStore = MainStore();
final taskStore = TaskStore();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB().init();
  await mainStore.init();
  await taskStore.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Aurora',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorObservers: [BotToastNavigatorObserver()],
      builder: BotToastInit(),
      initialRoute: '/',
      routes: {
        '/state': (context) => const StatePage(),
        '/': (context) => MainPage(),
        '/config': (context) => ConfigManager(),
      },
    );
  }
}
