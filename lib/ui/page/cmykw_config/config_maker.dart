import 'package:aurora/data/database/database.dart';
import 'package:aurora/data/database/database_helper.dart';
import 'package:aurora/data/proto/gen/config.pbserver.dart';
import 'package:aurora/main.dart';
import 'package:aurora/ui/components/app_bar.dart';
import 'package:aurora/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigMaker extends StatelessWidget {
  ConfigMaker({
    Key? key,
    this.entity,
  })  : nameController = TextEditingController(text: entity?.name ?? ''),
        tsController = TextEditingController(text: entity?.ts.toString() ?? ''),
        gkwMController =
            TextEditingController(text: entity?.gKwM.toString() ?? ''),
        gwMaxController =
            TextEditingController(text: entity?.gWMax.toString() ?? ''),
        gkMinMController =
            TextEditingController(text: entity?.gKMin.toString() ?? ''),
        gkw1Controller =
            TextEditingController(text: entity?.gKwM.toString() ?? ''),
        kaController = TextEditingController(text: entity?.ka.toString() ?? ''),
        kb1Controller =
            TextEditingController(text: entity?.kb1.toString() ?? ''),
        kb2Controller =
            TextEditingController(text: entity?.kb2.toString() ?? ''),
        kcController = TextEditingController(text: entity?.kc.toString() ?? ''),
        xy11Controller =
            TextEditingController(text: entity?.xy11.toString() ?? ''),
        xy12Controller =
            TextEditingController(text: entity?.xy12.toString() ?? ''),
        xy21Controller =
            TextEditingController(text: entity?.xy21.toString() ?? ''),
        xy22Controller =
            TextEditingController(text: entity?.xy22.toString() ?? ''),
        xy31Controller =
            TextEditingController(text: entity?.xy31.toString() ?? ''),
        xy32Controller =
            TextEditingController(text: entity?.xy32.toString() ?? ''),
        platformSpeedController =
            TextEditingController(text: entity?.platformSpeed.toString() ?? ''),
        super(key: key);

  final CMYKWConfigPB? entity;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController nameController;
  final TextEditingController tsController;

  final TextEditingController gkwMController;

  final TextEditingController gwMaxController;

  final TextEditingController gkMinMController;

  final TextEditingController gkw1Controller;

  final TextEditingController kaController;

  final TextEditingController kb1Controller;

  final TextEditingController kb2Controller;

  final TextEditingController kcController;

  final TextEditingController xy11Controller;

  final TextEditingController xy12Controller;

  final TextEditingController xy21Controller;

  final TextEditingController xy22Controller;

  final TextEditingController xy31Controller;

  final TextEditingController xy32Controller;

  final TextEditingController platformSpeedController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context, title: '添加配置'),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var autoSelect = false;

            if (entity != null) {
              await DB().configDao.deleteConfig(entity!.name);
              autoSelect = true;
            }

            final pb = CMYKWConfigPB(
              name: nameController.text,
              gKMin: gkMinMController.text.toDouble(),
              gKw1: gkw1Controller.text.toDouble(),
              gKwM: gkwMController.text.toDouble(),
              gWMax: gwMaxController.text.toDouble(),
              ka: kaController.text.toDouble(),
              kb1: kb1Controller.text.toDouble(),
              kb2: kb2Controller.text.toDouble(),
              kc: kcController.text.toDouble(),
              ts: tsController.text.toDouble(),
              xy11: xy11Controller.text.toDouble(),
              xy12: xy12Controller.text.toDouble(),
              xy21: xy21Controller.text.toDouble(),
              xy22: xy22Controller.text.toDouble(),
              xy31: xy31Controller.text.toDouble(),
              xy32: xy32Controller.text.toDouble(),
              platformSpeed: platformSpeedController.text.toDouble(),
            );

            final next = ConfigTableCompanion.insert(
              name: nameController.text,
              pb: pb.writeToBuffer(),
            );

            await DB().configDao.addConfig(next);
            if (autoSelect) mainStore.setCmykwConfig(pb);
            Navigator.of(context).pop();
          }
        },
      ),
    );
  }

  Widget buildBody() {
    final formatter = [FilteringTextInputFormatter.allow(RegExp(r'[0-9\.-]'))];
    final validator =
        (String? value) => value != null && value.isNotEmpty ? null : '该字段为必填项';

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: '名称'),
            validator: validator,
          ),
          TextFormField(
            controller: tsController,
            decoration: const InputDecoration(labelText: '转速基准'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: platformSpeedController,
            decoration: const InputDecoration(labelText: '测试平台速度'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: gkwMController,
            decoration: const InputDecoration(labelText: '最灰色值'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: gwMaxController,
            decoration: const InputDecoration(labelText: '最白色值'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: gkMinMController,
            decoration: const InputDecoration(labelText: '最黑色值'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: gkw1Controller,
            decoration: const InputDecoration(labelText: '黑阶分界值'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: kaController,
            decoration: const InputDecoration(labelText: '拟合参数a'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: kb1Controller,
            decoration: const InputDecoration(labelText: '拟合参数b1'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: kb2Controller,
            decoration: const InputDecoration(labelText: '拟合参数b2'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          TextFormField(
            controller: kcController,
            decoration: const InputDecoration(labelText: '拟合参数c'),
            keyboardType: TextInputType.number,
            inputFormatters: formatter,
            validator: validator,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: xy11Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(1, 1)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: xy12Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(1, 2)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: xy21Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(2, 1)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: xy22Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(2, 2)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: TextFormField(
                  controller: xy31Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(3, 1)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: TextFormField(
                  controller: xy32Controller,
                  decoration: const InputDecoration(labelText: '色彩配置矩阵(3, 2)'),
                  keyboardType: TextInputType.number,
                  inputFormatters: formatter,
                  validator: validator,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
