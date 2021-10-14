import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

Future<Color?> selectColorFromBoard(BuildContext context,
    [Color? defaultColor]) async {
  return await showDialog(
    context: context,
    builder: (context) {
      var currentColor = defaultColor ?? Colors.blue;
      return AlertDialog(
        title: const Text('选择一个颜色'),
        content: SingleChildScrollView(
          child: ColorPicker(
            pickerColor: currentColor,
            onColorChanged: (v) {
              currentColor = v;
            },
            showLabel: true,
            pickerAreaHeightPercent: 0.8,
            enableAlpha: false,
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(currentColor);
            },
            child: const Text('确定'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
          ),
        ],
      );
    },
  );
}

Future<Color?> selectColorFromMaterialPicker(BuildContext context,
    [Color? defaultColor]) async {
  return await showDialog(
    context: context,
    builder: (context) {
      var currentColor = defaultColor ?? Colors.blue;
      return AlertDialog(
        title: const Text('选择一个颜色'),
        content: SingleChildScrollView(
          child: MaterialPicker(
            pickerColor: currentColor,
            onColorChanged: (v) {
              currentColor = v;
            },
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(currentColor);
            },
            child: const Text('确定'),
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.blue),
                foregroundColor: MaterialStateProperty.all(Colors.white)),
          ),
        ],
      );
    },
  );
}

Future<Color?> selectColorByRGB(BuildContext context,
    [Color? defaultColor]) async {
  final currentColor = defaultColor ?? Colors.blue;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final validator = (String? value) {
    if (value?.isEmpty ?? true) {
      return '请输入数值';
    }
    return 0 <= int.tryParse(value!)! && int.tryParse(value)! <= 255
        ? null
        : '数值超出范围';
  };

  final rController = TextEditingController();
  final gController = TextEditingController();
  final bController = TextEditingController();

  rController.text = currentColor.red.toString();
  gController.text = currentColor.green.toString();
  bController.text = currentColor.blue.toString();

  var previewColor = currentColor;
  void genPreviewColor() {
    var r = int.tryParse(rController.text) ?? 0;
    if (r < 0 || r > 0xFF) r = 0;
    var g = int.tryParse(gController.text) ?? 0;
    if (g < 0 || g > 0xFF) g = 0;
    var b = int.tryParse(bController.text) ?? 0;
    if (b < 0 || b > 0xFF) b = 0;
    previewColor = Color.fromARGB(0xFF, r, g, b);
  }

  return await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          Widget buildTextForm({
            required TextEditingController controller,
            required String labelText,
          }) {
            return TextFormField(
              controller: controller,
              decoration: InputDecoration(
                labelText: labelText,
              ),
              validator: validator,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              onChanged: (value) {
                setState(() {
                  genPreviewColor();
                });
              },
            );
          }

          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '设置颜色',
                        style: TextStyle(fontSize: 20),
                      ),
                      Container(
                        width: 100,
                        height: 30,
                        decoration: BoxDecoration(
                            color: previewColor,
                            borderRadius: BorderRadius.circular(5)),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Form(
                    key: _formKey,
                    child: ListBody(
                      children: [
                        buildTextForm(
                          controller: rController,
                          labelText: 'R',
                        ),
                        buildTextForm(
                          controller: gController,
                          labelText: 'G',
                        ),
                        buildTextForm(
                          controller: bController,
                          labelText: 'B',
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('取消'),
                      ),
                      TextButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            Navigator.of(context).pop(Color.fromARGB(
                              0xFF,
                              int.parse(rController.value.text),
                              int.parse(gController.value.text),
                              int.parse(bController.value.text),
                            ));
                          }
                        },
                        child: const Text('确定'),
                        style: ButtonStyle(
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).primaryColor),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
      });
}
