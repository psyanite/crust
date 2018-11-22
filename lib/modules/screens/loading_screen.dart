import 'package:flutter/material.dart';

import 'package:crust/presentation/theme.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        body: new Center(
          child: new CircularProgressIndicator(
              backgroundColor: Burnt.background,
              strokeWidth: 2.0),
        ),
      ),
    );
  }
}
