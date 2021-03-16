import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('任务', style: TextStyle(fontSize: 18)),
        centerTitle: true,
          automaticallyImplyLeading: false,
      ),
    );
  }
}