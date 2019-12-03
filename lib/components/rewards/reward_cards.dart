import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class RewardCards extends StatelessWidget {
  final List<Reward> rewards;
  final bool confirmUnfavorite;

  RewardCards({Key key, this.rewards, this.confirmUnfavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        var reward = rewards[i];
        return Builder(builder: (context) {
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: reward.id))),
            child: _card(reward),
          );
        });
      }, childCount: rewards.length),
    );
  }

  Widget _card(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 16.0, bottom: 15.0, left: 16.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _cardPromoImage(reward),
            _cardBanner(reward),
            Container(height: 10.0),
            Text(reward.name, style: Burnt.titleStyle),
            Text('${reward.storeNameText()} · ${reward.locationText()}'),
            Text(reward.description),
          ],
        ),
      ),
    );
  }

  Widget _cardBanner(Reward reward) {
    var expired = reward.isExpired();
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      color: expired ? Burnt.primary : Burnt.separator,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(reward.bannerText(), style: TextStyle(color: expired ? Colors.white : Burnt.lightTextColor)),
      ]),
    );
  }

  Widget _cardPromoImage(Reward reward) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        NetworkImg(reward.promoImage, height: 200.0),
        FavoriteRewardButton(reward: reward, padding: EdgeInsets.all(15.0), size: 27.0, confirmUnfavorite: confirmUnfavorite),
      ],
    );
  }
}
