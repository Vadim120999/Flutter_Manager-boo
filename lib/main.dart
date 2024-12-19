import 'package:flutter/material.dart';
import 'appointments/appointments.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Book',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Flutter Book'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Appointments', icon: Icon(Icons.event)),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              Appointments(),
            ],
          ),
        ),
      ),
    );
  }
}
