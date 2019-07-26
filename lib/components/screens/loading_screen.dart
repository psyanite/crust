import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  LoadingScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
