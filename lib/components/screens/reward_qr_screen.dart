import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RewardQrScreen extends StatelessWidget {
  final UserReward userReward;

  RewardQrScreen({
    Key key,
    this.userReward,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  Widget _appBar() {
    return AppBar(
      leading: BackArrow(),
      backgroundColor: Colors.transparent, elevation: 0.0);
  }

  Widget _body() {
    if (userReward == null) {
      return LoadingCenter();
    }
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        QrImage(
          data: userReward.uniqueCode,
          size: 200.0,
          foregroundColor: Burnt.textBodyColor,
          version: 1,
        ),
        Text(userReward.uniqueCode, style: TextStyle(fontSize: 30.0, fontWeight: Burnt.fontBold)),
        Padding(
          padding: EdgeInsets.only(top: 5.0),
          child: Text('Simply show this code to the staff.'),
        ),
        Padding(
          padding: EdgeInsets.only(top: 5.0, bottom: 100.0),
          child: Text('Enjoy!'),
        )
      ]));
  }
}
