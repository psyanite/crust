import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/screens/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class RewardCards extends StatelessWidget {
  final List<Reward> rewards;
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final bool isLoggedIn;
  final String layout;

  RewardCards({this.rewards, this.favoriteRewards, this.favoriteReward, this.unfavoriteReward, this.isLoggedIn, this.layout});

  @override
  Widget build(BuildContext context) {
    var type = layout == 'card' ? _card : _listItem;
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          (context, i) {
          var reward = rewards[i];
          return Builder(builder: (context) =>
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RewardScreen(rewardId: reward.id)),
                );
              },
              child: type(reward)
            )
          );
        },
        childCount: rewards.length
      ),
    );
  }

  Widget _card(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, right: 15.0, bottom: 10.0, left: 15.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _cardPromoImage(reward),
            _cardBanner(reward),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Text(reward.name, style: Burnt.title),
            ),
            Text(reward.locationText()),
            Text(reward.description),
          ],
        ),
      ),
    );
  }

  Widget _listItem(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 15.0, bottom: 10.0, left: 15.0),
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
                      child: Text(reward.name, style: Burnt.title),
                    ),
                    Text(reward.locationText()),
                    Text(reward.description),
                    _listItemBanner(reward),
                  ],
                ),
              ),
              _listItemPromoImage(reward),
            ],
          ),
        ),
      ),
    );
  }

  Widget _cardBanner(Reward reward) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      color: Burnt.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(reward.bannerText(), style: TextStyle(color: Colors.white)),
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
            image: DecorationImage(
              image: NetworkImage(reward.promoImage),
              fit: BoxFit.cover,
            ),
          )),
        _favoriteButton(reward),
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
            image: DecorationImage(
              image: NetworkImage(reward.promoImage),
              fit: BoxFit.cover,
            ),
          )),
        _favoriteButton(reward)
      ],
    );
  }

  Widget _favoriteButton(Reward reward) {
    return Builder(
      builder: (context) =>
        FavoriteButton(
          isFavorited: favoriteRewards.contains(reward.id),
          onFavorite: () {
            if (isLoggedIn) {
              favoriteReward(reward.id);
              snack(context, 'Added to favourites');
            } else {
              snack(context, 'Please login to favorite rewards');
            }
          },
          onUnfavorite: () {
            unfavoriteReward(reward.id);
            snack(context, 'Removed from favourites');
          }));
  }
}
