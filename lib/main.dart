import 'package:blue_demo/ui/data/store/main_store.dart';
import 'package:blue_demo/ui/page/device/device_page.dart';
import 'package:blue_demo/ui/page/home/home_page.dart';
import 'package:blue_demo/ui/page/search/search_page.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await mainStore.init();
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
        '/': (context) => HomePage(),
        '/search': (context) => SearchPage(),
        '/device': (context) => DevicePage()
      },
    );
  }
}
