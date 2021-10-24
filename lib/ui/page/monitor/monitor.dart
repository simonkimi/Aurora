import 'dart:typed_data';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get/get.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({Key? key}) : super(key: key);

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: buildAppBar(context, title: '监控', displayBack: false),
      body: buildBody(),
    );
  }

  @override
  void initState() {
    super.initState();
    monitorStore.findPiIp();
  }

  Widget buildBody() {
    return Observer(builder: (context) {
      if (monitorStore.isScanning) {
        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 20),
              Text('搜索设备中...')
            ],
          ),
        );
      }

      if (monitorStore.ip == null) {
        return InkWell(
          onTap: () {
            monitorStore.findPiIp();
          },
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.not_listed_location, size: 50),
                SizedBox(height: 10),
                Text('没有找到设备, 点击重试'),
              ],
            ),
          ),
        );
      }

      return ListView(
        children: [
          buildColor(),
          buildVideo(),
          const SizedBox(height: 5),
          buildChart(),
        ],
      );
    });
  }

  Widget buildColor() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        child: ListTile(
          leading: Obx(() => CircleAvatar(
                backgroundColor: monitorStore.centerColor.value,
                child: const SizedBox(),
              )),
          title: const Text('识别颜色'),
          subtitle: Obx(() => Text(
              'R: ${monitorStore.centerColor.value.red} G: ${monitorStore.centerColor.value.green} B: ${monitorStore.centerColor.value.blue}')),
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
          child: Obx(() => LineChart(LineChartData(
                minX: monitorStore.colorDeltaE.isEmpty
                    ? 0
                    : monitorStore.colorDeltaE.first.x,
                maxX: monitorStore.colorDeltaE.isEmpty
                    ? 0
                    : monitorStore.colorDeltaE.last.x,
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
                    spots: monitorStore.colorDeltaE.toList(),
                    dotData: FlDotData(
                      show: false,
                    ),
                    colors: [Colors.red],
                    colorStops: [0.1, 1.0],
                    barWidth: 3,
                    isCurved: false,
                  )
                ],
              ))),
        ),
      ),
    );
  }

  Widget buildVideo() {
    return Padding(
      padding: const EdgeInsets.all(3),
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: StreamBuilder<List<int>>(
          stream: monitorStore.videoStream,
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

  @override
  bool get wantKeepAlive => true;
}
