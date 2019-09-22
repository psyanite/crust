import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RewardsSideScroller extends StatelessWidget {
  final List<UserReward> userRewards;
  final List<Reward> rewards;
  final String title;
  final Function seeAll;
  final String emptyMessage;
  final bool showExpiredBanner;
  final bool confirmUnfavorite;

  RewardsSideScroller({Key key, this.userRewards, this.rewards, this.title, this.seeAll, this.emptyMessage, this.showExpiredBanner = false, this.confirmUnfavorite = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rewards != null) {
      var widgets = List<Widget>.from(rewards.take(5).map((r) {
        var onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: r.id)));
        return _card(onTap, r);
      }));
      return _list(widgets, seeAll);
    } else {
      var widgets = List<Widget>.from(userRewards.take(5).map((u) {
        var onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: u.rewardId)));
        return _card(onTap, u.reward);
      }));
      return _list(widgets, seeAll);
    }
  }

  Widget _list(List<Widget> children, Function seeAll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 23.0, fontWeight: Burnt.fontBold)),
              if (children.isNotEmpty) InkWell(
                  child: Text('See All', style: TextStyle(fontSize: 14.0, fontWeight: Burnt.fontBold, color: Burnt.primary)),
                  onTap: seeAll)
            ],
          ),
        ),
        if (children.isNotEmpty)
          Container(
              margin: EdgeInsets.only(left: 16.0), height: 180.0, child: ListView(scrollDirection: Axis.horizontal, children: children)),
        if (children.isEmpty) Container(margin: EdgeInsets.symmetric(horizontal: 16.0), child: Text(emptyMessage)),
      ],
    );
  }

  Widget _card(Function onTap, Reward reward) {
    return Builder(
        builder: (context) => InkWell(
            onTap: onTap,
            child: Container(
                width: 202.0,
                height: 202.0,
                padding: EdgeInsets.only(right: 10.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Stack(
                    children: <Widget>[
                    Container(
                      width: 200.0,
                      height: 100.0,
                        padding: EdgeInsets.all(1.0),
                        color: Burnt.imgPlaceholderColor,
                        child: Image.network(reward.promoImage, fit: BoxFit.cover)),
                    Positioned(
                      top: 0.0,
                      right: 0.0,
                      child: FavoriteRewardButton(reward: reward, padding: EdgeInsets.all(7.0), confirmUnfavorite: confirmUnfavorite)
                    ),
                    if (showExpiredBanner == true && reward.isExpired() == true)
                      Positioned(
                        bottom: 0.0,
                        child: Container(
                        width: 200.0,
                        padding: EdgeInsets.symmetric(vertical: 7.0),
                        color: Burnt.separator,
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Text('Expired', style: TextStyle(color: Burnt.lightTextColor)),
                        ]),
                      ))
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(height: 5.0),
                    Text(reward.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text('${reward.storeNameText()} · ${reward.locationText()}', style: TextStyle(fontSize: 14.0)),
                  ])
                ]))));
  }
}
