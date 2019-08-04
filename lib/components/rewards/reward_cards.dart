import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class RewardCards extends StatelessWidget {
  final List<Reward> rewards;
  final String layout;
  final bool confirmUnfavorite;

  RewardCards({Key key, this.rewards, this.layout, this.confirmUnfavorite}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var type = layout == 'card' ? _card : _listItem;
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        var reward = rewards[i];
        return Builder(builder: (context) {
          return InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: reward.id))),
            child: type(reward),
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

  Widget _listItem(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 16.0, bottom: 10.0, left: 16.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 10.0),
                      child: Text(reward.name, style: Burnt.titleStyle),
                    ),
                    Text('${reward.storeNameText()} · ${reward.locationText()}'),
                    Text(reward.description),
                    _listItemBanner(reward),
                  ],
                ),
              ),
              Container(width: 10.0),
              _listItemPromoImage(reward),
            ],
          ),
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

  Widget _listItemBanner(Reward reward) {
    return Text(reward.bannerText(), style: TextStyle(fontWeight: Burnt.fontBold, color: Burnt.primary));
  }

  Widget _cardPromoImage(Reward reward) {
    return Stack(
      alignment: AlignmentDirectional.topEnd,
      children: <Widget>[
        Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                image: NetworkImage(reward.promoImage),
                fit: BoxFit.cover,
              ),
            )),
        FavoriteRewardButton(reward: reward, padding: EdgeInsets.all(15.0), size: 27.0, confirmUnfavorite: confirmUnfavorite),
      ],
    );
  }

  Widget _listItemPromoImage(Reward reward) {
    return Stack(
      alignment: AlignmentDirectional.center,
      children: <Widget>[
        Container(
            width: 80.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                image: NetworkImage(reward.promoImage),
                fit: BoxFit.cover,
              ),
            )),
        FavoriteRewardButton(reward: reward, confirmUnfavorite: confirmUnfavorite)
      ],
    );
  }
}
