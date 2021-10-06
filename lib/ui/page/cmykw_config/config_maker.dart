import 'package:blue_demo/data/database/database_helper.dart';
import 'package:blue_demo/data/database/entity/config_entity.dart';
import 'package:blue_demo/main.dart';
import 'package:blue_demo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ConfigMaker extends StatelessWidget {
  ConfigMaker({
    Key? key,
    this.entity,
  })  : nameController = TextEditingController(text: entity?.name ?? ''),
        tsController = TextEditingController(text: entity?.ts.toString() ?? ''),
        gkwMController =
            TextEditingController(text: entity?.G_kwM.toString() ?? ''),
        gwMaxController =
            TextEditingController(text: entity?.G_W_max.toString() ?? ''),
        gkMinMController =
            TextEditingController(text: entity?.G_K_min.toString() ?? ''),
        gkw1Controller =
            TextEditingController(text: entity?.G_kw1.toString() ?? ''),
        kaController = TextEditingController(text: entity?.Ka.toString() ?? ''),
        kb1Controller =
            TextEditingController(text: entity?.Kb1.toString() ?? ''),
        kb2Controller =
            TextEditingController(text: entity?.Kb2.toString() ?? ''),
        kcController = TextEditingController(text: entity?.Kc.toString() ?? ''),
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
        super(key: key);

  final ConfigEntity? entity;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.check),
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            var autoSelect = false;
            final entity = await DB().configDao.get(nameController.text);
            if (entity != null) {
              await DB().configDao.deleteConfig(nameController.text);
              autoSelect = true;
            }
            final next = ConfigEntity(
              name: nameController.text,
              G_K_min: gkMinMController.text.toDouble(),
              G_kw1: gkw1Controller.text.toDouble(),
              G_kwM: gkwMController.text.toDouble(),
              G_W_max: gwMaxController.text.toDouble(),
              Ka: kaController.text.toDouble(),
              Kb1: kb1Controller.text.toDouble(),
              Kb2: kb2Controller.text.toDouble(),
              Kc: kcController.text.toDouble(),
              ts: tsController.text.toDouble(),
              xy11: xy11Controller.text.toDouble(),
              xy12: xy12Controller.text.toDouble(),
              xy21: xy21Controller.text.toDouble(),
              xy22: xy22Controller.text.toDouble(),
              xy31: xy31Controller.text.toDouble(),
              xy32: xy32Controller.text.toDouble(),
            );
            await DB().configDao.addConfig(next);
            if (autoSelect)
              mainStore.setCmykwConfig(next);
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

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text(
        '添加配置',
        style: TextStyle(fontSize: 18),
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios,
          size: 18,
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    );
  }
}
