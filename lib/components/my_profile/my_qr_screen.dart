import 'package:crust/presentation/components.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrScreen extends StatelessWidget {
  final int userId;

  MyQrScreen({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      QrImage(
        data: Utils.buildProfileQrCode(userId),
        size: 300.0,
        foregroundColor: Colors.white,
        version: 2,
      ),
      Container(height: 10.0),
      Text('Ask your friend to scan your secret code.', style: TextStyle(color: Colors.white, fontSize: 20.0)),
    ];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.6, 1.0],
            colors: [Color(0xFFffc86b), Color(0xFFffab40), Color(0xFFc45d35)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _appBar(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
            Container(height: 200.0),
          ]
        ),
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 85.0, bottom: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Stack(
          children: <Widget>[
            Container(width: 50.0, height: 60.0),
            Positioned(left: -12.0, child: BackArrow(color: Colors.white)),
          ],
        ),
      ]),
    );
  }
}
