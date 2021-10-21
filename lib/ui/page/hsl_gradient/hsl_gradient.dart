import 'package:aurora/data/constant.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/ui/components/color_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HslGradient extends StatelessWidget {
  const HslGradient({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '渐变色'),
      body: Observer(
        builder: (context) {
          return ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      const Text('RGB'),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('开始:'),
                          const SizedBox(width: 10),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: gradientStore.startRgb,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: InkWell(
                              onTap: () async {
                                final color = await showSelectColor(
                                    context, gradientStore.startRgb);
                                if (color != null) {
                                  gradientStore.startRgb = color;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text('结束:'),
                          const SizedBox(width: 10),
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                                color: gradientStore.endRgb,
                                borderRadius: BorderRadius.circular(50)),
                            child: InkWell(
                              onTap: () async {
                                final color = await showSelectColor(
                                    context, gradientStore.endRgb);
                                if (color != null) {
                                  gradientStore.endRgb = color;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: !gradientStore.isLock
                                ? () {
                                    gradientStore.genRgbColorList();
                                  }
                                : null,
                            child: const Text('生成'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              buildHSLCard(),
              buildControllerCard(),
            ],
          );
        },
      ),
    );
  }

  Card buildControllerCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            const Text('控制'),
            Row(
              children: [
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.step.toString(),
                  decoration: const InputDecoration(labelText: '切片数'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final data = int.tryParse(value);
                    if (data != null) {
                      gradientStore.step = data;
                    }
                  },
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.timer.toString(),
                  decoration: const InputDecoration(labelText: '间隔'),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (value) {
                    final data = int.tryParse(value);
                    if (data != null) {
                      gradientStore.timer = data;
                    }
                  },
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 100,
                  child: TextFormField(
                    controller:
                        TextEditingController.fromValue(TextEditingValue(
                      text: (gradientStore.currentStep + 1).toString(),
                      selection: TextSelection.fromPosition(TextPosition(
                        offset:
                            (gradientStore.currentStep + 1).toString().length,
                        affinity: TextAffinity.downstream,
                      )),
                    )),
                    enabled: !gradientStore.isLock,
                    decoration: const InputDecoration(
                      labelText: '当前切片',
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      isDense: true,
                    ),
                    onChanged: (value) {
                      final data = int.tryParse(value);
                      if (data != null) {
                        if (data - 1 >= gradientStore.step) {
                          gradientStore.currentStep = gradientStore.step - 1;
                        } else if (data - 1 >= 0) {
                          gradientStore.currentStep = data - 1;
                        }
                      }
                    },
                  ),
                ),
                Container(
                  width: 100,
                  height: 30,
                  decoration: BoxDecoration(
                    color: gradientStore.colorList[gradientStore.currentStep],
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: gradientStore.colorList.map((color) {
                return Expanded(
                    child: SizedBox(
                  height: 20,
                  child: ColoredBox(
                    color: color,
                  ),
                ));
              }).toList(),
            ),
            LinearProgressIndicator(
              value: gradientStore.currentStep / gradientStore.step,
              backgroundColor: Colors.white,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                    onPressed: gradientStore.isLock
                        ? () {
                            gradientStore.stopAndBreak();
                          }
                        : null,
                    child: const Text('停止')),
                TextButton(
                    onPressed: !gradientStore.isLock
                        ? () {
                            gradientStore.currentStep = 0;
                          }
                        : null,
                    child: const Text('重置')),
                TextButton(
                    onPressed: !gradientStore.isLock
                        ? () {
                            gradientStore.startSend();
                          }
                        : null,
                    child: const Text('开始')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Card buildHSLCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('HSL'),
            Row(
              children: [
                const Text('起始颜色'),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.startH.toString(),
                  decoration: const InputDecoration(labelText: 'H'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 360) {
                      gradientStore.startH = data;
                    }
                  },
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.startS.toString(),
                  decoration: const InputDecoration(labelText: 'S'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 360) {
                      gradientStore.startS = data;
                    }
                  },
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.startL.toString(),
                  decoration: const InputDecoration(labelText: 'L'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 1) {
                      gradientStore.startL = data;
                    }
                  },
                )),
              ],
            ),
            Row(
              children: [
                const Text('结束颜色'),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.endH.toString(),
                  decoration: const InputDecoration(labelText: 'H'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 360) {
                      gradientStore.endH = data;
                    }
                  },
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.endS.toString(),
                  decoration: const InputDecoration(labelText: 'S'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 1) {
                      gradientStore.endS = data;
                    }
                  },
                )),
                const SizedBox(width: 10),
                Expanded(
                    child: TextFormField(
                  initialValue: gradientStore.endL.toString(),
                  decoration: const InputDecoration(labelText: 'L'),
                  inputFormatters: floatFormatter,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    final data = double.tryParse(value);
                    if (data != null && data >= 0 && data <= 1) {
                      gradientStore.endL = data;
                    }
                  },
                )),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: !gradientStore.isLock
                      ? () {
                          gradientStore.genHlsColorList();
                        }
                      : null,
                  child: const Text('生成'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
