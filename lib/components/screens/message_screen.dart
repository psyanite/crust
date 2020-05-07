import 'package:crust/presentation/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  final String message;

  MessageScreen({Key key, this.message = 'Oops! Something went wrong.'}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(message),
            Container(height: 15.0),
            SmallButton(child: Text('Go Back', style: TextStyle(color: Colors.white)), padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 12.0, right: 12.0), onTap: () => Navigator.pop(context)),
          ],
        ),
      ),
    );
  }
}
