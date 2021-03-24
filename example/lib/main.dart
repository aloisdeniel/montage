import 'package:example/scene.dart';
import 'package:flutter/material.dart';
import 'package:montage/montage.dart';

import 'simple_scene.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  MontageController? controller;

  @override
  void initState() {
    controller = MontageController(
      vsync: this,
      initialAnimation: entrance,
    );
    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ValueListenableBuilder<MontageAnimation?>(
          valueListenable: controller!.current,
          builder: (context, current, child) => Text(current?.key ?? 'none'),
        ),
      ),
      body: Montage(
        controller: controller!,
        child: BasicScene(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller!.play([
            entrance,
            exit,
            entrance,
            idle,
            exit,
          ]);
        },
        label: Text('Play'),
        icon: Icon(Icons.video_call),
      ),
    );
  }
}
