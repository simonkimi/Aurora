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

  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('设置颜色'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: ListBody(
                children: [
                  TextFormField(
                    controller: rController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'R',
                    ),
                    validator: validator,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  TextFormField(
                    controller: gController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'G',
                    ),
                    validator: validator,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                  TextFormField(
                    controller: bController,
                    decoration: const InputDecoration(
                      labelText: 'B',
                    ),
                    validator: validator,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                  ),
                ],
              ),
            ),
          ),
          actions: [
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
                foregroundColor: MaterialStateProperty.all(Colors.white),
                backgroundColor:
                    MaterialStateProperty.all(Theme.of(context).primaryColor),
              ),
            )
          ],
        );
      });
}
