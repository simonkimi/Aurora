import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 198, 40, 40),
              ),
              title: Text('#C62828'),
              subtitle: Text('C: 1.0%  M: 29.5%  Y: 57.5%  K: 0.0%  W: 12.0%'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 100, 255, 218),
              ),
              title: Text('#C62828'),
              subtitle: Text('C: 49.5%  M: 11.0%  Y: 0.0%  K: 0.0%  W: 39.0%'),
            ),
          ),
          Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Color.fromARGB(255, 61, 90, 254),
              ),
              title: Text('#C62828'),
              subtitle: Text('C: 54.5%  M: 0.0%  Y: 21.5%  K: 0.0%  W: 24.5%'),
            ),
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: Text('任务', style: TextStyle(fontSize: 18)),
      centerTitle: true,
        automaticallyImplyLeading: false,
    );
  }
}
