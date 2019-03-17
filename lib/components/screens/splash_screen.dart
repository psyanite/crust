import 'dart:async';

import 'package:crust/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    return Timer(Duration(seconds: 3), () {
      Navigator.popAndPushNamed(
        context,
        MainRoutes.root,
      );
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
        body: Container(
            child: Center(
              child: Image.asset('assets/images/loading-icon.png', height: 200.0),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [0, 0.6, 1.0],
              colors: [Color(0xFFffc86b), Color(0xFFffab40), Color(0xFFc45d35)],
            ))));
  }
}
