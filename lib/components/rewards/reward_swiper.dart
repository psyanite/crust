import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class RewardSwiper extends StatelessWidget {
  final Widget header;
  final List<Reward> rewards;

  RewardSwiper({Key key, this.header, this.rewards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        header,
        Container(
          height: 290.0,
          child: Swiper(
            loop: false,
            containerHeight: 220.0,
            itemBuilder: (BuildContext context, int i) {
              return Stack(
                children: <Widget>[
                  Container(height: 220.0),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(2.0)),
                      boxShadow: [BoxShadow(color: Color(0x10000000), offset: Offset(2.0, 2.0), blurRadius: 1.0, spreadRadius: 1.0)],
                    ),
                    child: _card(rewards[i]),
                  ),
                ],
              );
            },
            itemCount: rewards.length,
            viewportFraction: 0.8,
            scale: 0.9,
          ),
        ),
      ],
    );
  }

  Widget _card(Reward reward) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: reward.id))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                NetworkImg(reward.promoImage, height: 150.0, fit: BoxFit.cover),
                FavoriteRewardButton(reward: reward, size: 30.0, padding: EdgeInsets.all(20.0)),
              ],
            ),
            Container(height: 20.0),
            Text(reward.name, overflow: TextOverflow.ellipsis, style: Burnt.titleStyle.copyWith(fontSize: 22.0)),
            Container(height: 2.0),
            Text(reward.storeNameText(), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0)),
            Container(height: 2.0),
            Text(reward.locationText(), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0)),
            Container(height: 3.0),
            Text(reward.bannerText(), overflow: TextOverflow.ellipsis, style: TextStyle(color: Burnt.hintTextColor, fontSize: 16.0)),
            Container(height: 20.0),
          ],
        ),
      );
    });
  }
}
