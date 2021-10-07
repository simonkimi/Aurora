import 'package:flutter/material.dart';

AppBar buildAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
}) {
  return AppBar(
    title: Text(
      title,
      style: const TextStyle(fontSize: 18),
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
    actions: actions,
  );
}
