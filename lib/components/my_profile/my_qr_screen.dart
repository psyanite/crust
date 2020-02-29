import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class MyQrScreen extends StatelessWidget {
  final int userId;

  MyQrScreen({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Burnt.burntGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            QrImage(
              data: Utils.buildProfileQrCode(userId),
              size: 300.0,
              foregroundColor: Colors.white,
              version: 2,
            ),
            Container(height: 10.0),
            Text('Ask your friend to scan your secret code.', style: TextStyle(color: Colors.white, fontSize: 20.0)),
            Container(height: 30.0),
            WhiteBackButton(),
          ],
        ),
      ),
    );
  }
}
