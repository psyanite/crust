import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class RewardQrScreen extends StatelessWidget {
  final UserReward userReward;
  final Reward reward;

  RewardQrScreen({Key key, this.userReward, this.reward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _body()),
    );
  }

  Widget _body() {
    if (userReward == null) return LoadingCenter();
    var boldStyle = TextStyle(fontSize: 30.0, fontWeight: Burnt.fontBold);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(reward.name, textAlign: TextAlign.center, style: boldStyle),
        Container(height: 5.0),
        Text(reward.storeNameText(), textAlign: TextAlign.center, style: boldStyle),
        Container(height: 20.0),
        QrImage(data: userReward.uniqueCode, size: 200.0, foregroundColor: Burnt.textBodyColor, version: 1),
        Text(userReward.uniqueCode, style: boldStyle),
        Container(height: 5.0),
        Text('Simply show this code to the staff.'),
        Container(height: 5.0),
        Text('Enjoy!'),
        Container(height: 100.0),
        SolidBackButton(),
      ],
    );
  }
}
