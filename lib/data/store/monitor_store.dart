import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:blue_demo/main.dart';
import 'package:blue_demo/utils/udp_client.dart';
import 'package:dio/dio.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:mobx/mobx.dart';

part 'monitor_store.g.dart';

class MonitorStore = MonitorStoreBase with _$MonitorStore;

abstract class MonitorStoreBase with Store {
  final limitCount = 100;
  var timeLine = 0.0;
  StreamSubscription? listener;

  @observable
  String? ip;

  final centerColor = mainStore.selectColor.obs;
  final colorDeltaE = <FlSpot>[].obs;

  Future<void> findPiIp() async {
    ip ??= await UdpClient().findPi();
    if (ip != null && listener == null) {
      loadLine();
    }
  }

  Stream<List<int>> loadImagesData() {
    final stream = StreamController<List<int>>();
    final uri = Uri.parse('http://$ip:8888/stream');
    http.Client().send(http.Request('GET', uri)).then((response) {
      final pipe = <int>[];
      response.stream.listen((event) {
        pipe.addAll(event);
        final reg = RegExp(r'\-\-\-\-([\s\S]+?)\+\+\+\+');
        while (true) {
          final pipeString = String.fromCharCodes(pipe);
          final matches = reg.allMatches(pipeString);
          if (matches.isNotEmpty) {
            stream.add(
                pipe.sublist(matches.first.start + 4, matches.first.end - 4));
            pipe.removeRange(matches.first.start, matches.first.end);
          } else {
            break;
          }
        }
      });
    });
    return stream.stream.asBroadcastStream();
  }

  Future<void> loadLine() async {
    listener = Stream.periodic(const Duration(milliseconds: 500))
        .listen((event) async {
      try {
        if (ip != null) {
          final rsp = await Dio().get<String>('http://$ip:8888/color');
          final color = rsp.data!.split('|').map((e) => int.parse(e)).toList();

          final r = color[0];
          final g = color[1];
          final b = color[2];
          centerColor.value = Color.fromARGB(0xFF, r, g, b);
          final targetColor = mainStore.selectColor;
          while (colorDeltaE.length > limitCount) {
            colorDeltaE.removeAt(0);
          }

          final value = pow(
              ((r - targetColor.red).abs() +
                      (g - targetColor.green).abs() +
                      (b - targetColor.blue).abs()) /
                  50,
              0.5) as double;

          colorDeltaE.add(FlSpot(timeLine, value));
          timeLine += 1;
        }
      } catch (e) {
        print('cache $e');
      }
    });
  }
}
