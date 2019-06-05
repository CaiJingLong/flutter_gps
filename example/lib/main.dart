import 'package:flutter/material.dart';
import 'package:gps/gps.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GpsLatlng latlng;

  @override
  void initState() {
    super.initState();
    initGps();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('gps is :$latlng'),
        ),
      ),
    );
  }

  void initGps() async {
    var gps = await Gps.currentGps();
    this.latlng = gps;
    setState(() {});
  }
}
