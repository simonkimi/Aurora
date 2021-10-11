import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:aurora/main.dart';
import 'package:aurora/utils/udp_client.dart';
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

  @observable
  bool isScanning = false;

  final centerColor = mainStore.selectColor.obs;
  final colorDeltaE = <FlSpot>[].obs;

  StreamSubscription<List<int>>? videoListener;

  final _videoStreamController = StreamController<List<int>>.broadcast();

  Stream<List<int>> get videoStream =>
      _videoStreamController.stream;

  Future<void> findPiIp() async {
    isScanning = true;
    ip ??= await UdpClient().findPi();
    print('查找到ip: $ip');
    if (ip != null && listener == null) {
      videoListener = loadImagesData().listen((event) {
        _videoStreamController.add(event);
      });
      loadLine();
    }
    isScanning = false;
  }

  Stream<List<int>> loadImagesData() {
    final stream = StreamController<List<int>>();
    final uri = Uri.parse('http://$ip:8888/stream');

    final codeLine = '-'.codeUnitAt(0);
    final codePlus = '+'.codeUnitAt(0);

    http.Client().send(http.Request('GET', uri)).then((response) {
      final pipe = <int>[];

      bool breakOuter(List<int> pipe) {
        for (var i = 0; i < pipe.length; i++) {
          if (pipe[i] == codePlus) {
            if (i + 4 < pipe.length &&
                pipe.sublist(i, i + 4).every((e) => e == codePlus)) {
              final start = pipe.indexOf(codeLine);
              stream.add(pipe.sublist(start + 4, i));
              pipe.removeRange(start, i + 4);
              return false;
            }
          }
        }
        return true;
      }

      response.stream.listen((event) {
        pipe.addAll(event);
        while (true) {
          if (breakOuter(pipe)) break;
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

  void dispose() {
    listener?.cancel();
    videoListener?.cancel();
    _videoStreamController.close();
  }
}
