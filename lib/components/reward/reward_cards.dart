import 'package:crust/components/favorite_button.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
    return SliverList(
      delegate: SliverChildListDelegate(List<Widget>.from(rewards.map(layout == 'card' ? _card : _listItem))),
    );
  }

  Widget _card(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0, bottom: 20.0, left: 15.0),
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
            _locationText(reward),
            Text(reward.description),
          ],
        ),
      ),
    );
  }

  Widget _listItem(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0, bottom: 20.0, left: 15.0),
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
                    _locationText(reward),
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
        Text(_getBannerText(reward), style: TextStyle(color: Colors.white)),
      ]),
    );
  }

  Widget _listItemBanner(Reward reward) {
    return Text(_getBannerText(reward), style: TextStyle(fontWeight: Burnt.fontBold, color: Burnt.primary));
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
      builder: (context) => FavoriteButton(
            isFavorited: favoriteRewards.contains(reward.id),
            onFavorite: () {
              if (isLoggedIn) {
                favoriteReward(reward.id);
              } else {
                _snack(context, 'Please login to favorite rewards');
              }
            },
            onUnfavorite: () {
              unfavoriteReward(reward.id);
            },
          ),
    );
  }

  String _getBannerText(Reward reward) {
    var today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var firstDay = reward.validFrom;
    var lastDay = reward.validUntil;
    if (firstDay != null && lastDay != null) {
      if (firstDay == lastDay) {
        if (today == firstDay) return 'Only available TODAY. Get in quick!';
        return 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} · One Day Only';
      } else {
        if (firstDay.isBefore(today)) return 'Hurry! Only available until ${DateFormat.MMMEd("en_US").format(lastDay)}';
        return 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} - ${DateFormat.MMMEd("en_US").format(lastDay)}';
      }
    } else if (firstDay == null) {
      return 'Available today until ${DateFormat.MMMEd("en_US").format(lastDay)}';
    } else {
      return 'Available from the ${DateFormat.MMMEd("en_US").format(firstDay)}';
    }
  }

  Widget _locationText(Reward reward) {
    var store = reward.store;
    if (store != null) {
      var text = store.name;
      if (store.suburb != null) text = '$text · ${store.suburb}';
      text = '$text, ${store.location}';
      return Text(text);
    }
    var stores = reward.storeGroup.stores;
    var text = stores.take(2).map((s) {
      return s.suburb != null ? s.suburb : s.location;
    }).join(', ');
    text = '${reward.storeGroup.name} · $text';
    if (stores.length > 2) text = '$text, +${stores.length - 2} locations';
    return Text(text);
  }

  void _snack(BuildContext context, String message) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(message),
      action: SnackBarAction(
        label: 'Okay',
        onPressed: () {},
      ),
    ));
  }
}
