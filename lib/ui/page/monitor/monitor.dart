import 'dart:async';
import 'dart:typed_data';
import 'package:blue_demo/utils/udp_client.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:http/http.dart' as http;
import 'monitor_store.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}) : super(key: key);

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> with AutomaticKeepAliveClientMixin {
  final store = MonitorStore();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    store.dispose();
  }

  Widget buildBody() {
    return FutureBuilder<String>(
      future: UdpClient().findPi(),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          print('取得IP: ${snapshot.data}');
          if (store.ip == null) {
            store.ip = snapshot.data!;
            store.loadLine();
          }
          store.ip = snapshot.data!;
          return Column(
            children: [
              Observer(builder: (context) => buildColor()),
              buildVideo(snapshot.data!),
              const SizedBox(height: 5),
              Observer(builder: (context) => buildChart()),
            ],
          );
        }
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget buildColor() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: store.nowColor,
            child: const SizedBox(),
          ),
          title: const Text('识别颜色'),
          subtitle: Text(
              'R: ${store.nowColor.red} G: ${store.nowColor.green} B: ${store.nowColor.blue}'),
        ),
      ),
    );
  }

  Widget buildChart() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          height: 300,
          child: LineChart(LineChartData(
            minX: store.colorDeltaE.isEmpty ? 0 : store.colorDeltaE.first.x,
            maxX: store.colorDeltaE.isEmpty ? 0 : store.colorDeltaE.last.x,
            minY: 0,
            lineTouchData: LineTouchData(enabled: false),
            clipData: FlClipData.none(),
            axisTitleData: FlAxisTitleData(
              leftTitle: AxisTitle(
                titleText: 'ΔE',
                showTitle: true,
                margin: 0,
                reservedSize: 2,
              ),
              bottomTitle: AxisTitle(titleText: '时间', showTitle: true),
            ),
            titlesData: FlTitlesData(
              show: true,
              topTitles: SideTitles(showTitles: false),
              bottomTitles: SideTitles(showTitles: false),
              rightTitles: SideTitles(showTitles: true),
              leftTitles: SideTitles(showTitles: true),
            ),
            lineBarsData: [
              LineChartBarData(
                spots: store.colorDeltaE.toList(),
                dotData: FlDotData(
                  show: false,
                ),
                colors: [Colors.red],
                colorStops: [0.1, 1.0],
                barWidth: 3,
                isCurved: false,
              )
            ],
          )),
        ),
      ),
    );
  }

  Widget buildVideo(String ip) {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: StreamBuilder<List<int>>(
          stream: _loadImagesData(ip),
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const AspectRatio(
                aspectRatio: 320 / 240,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return Image.memory(
              Uint8List.fromList(snapshot.data!),
              gaplessPlayback: true,
            );
          },
        ),
      ),
    );
  }

  Stream<List<int>> _loadImagesData(String ip) {
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

  AppBar buildAppBar() {
    return AppBar(
      title: const Text(
        '监控',
        style: TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
    );
  }

  @override
  bool get wantKeepAlive => true;
}
