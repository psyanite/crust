import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RewardCards extends StatelessWidget {
  final List<Reward> rewards;

  RewardCards({this.rewards});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(List<Widget>.from(rewards.map(_rewardCard))),
    );
  }

  Widget _rewardCard(Reward reward) {
    return Padding(
      padding: EdgeInsets.only(right: 15.0, bottom: 20.0, left: 15.0),
      child: Container(
        padding: EdgeInsets.only(bottom: 20.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _promoImage(reward),
            _banner(reward),
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

  Widget _banner(Reward reward) {
    var firstDay = reward.validFrom;
    var lastDay = reward.validUntil;
    var today = new DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
    var bannerText;
    if (firstDay != null && lastDay != null) {
      if (firstDay == lastDay) {
        bannerText = today == firstDay
            ? 'Only available TODAY. Get in quick!'
            : 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} · One Day Only';
      } else {
        bannerText = firstDay.isBefore(today)
            ? 'Hurry! Only available until ${DateFormat.MMMEd("en_US").format(lastDay)}'
            : 'Coming Soon · ${DateFormat.MMMEd("en_US").format(firstDay)} - ${DateFormat.MMMEd("en_US").format(lastDay)}';
      }
    }
    return Container(
      padding: EdgeInsets.symmetric(vertical: 7.0),
      color: Burnt.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Text(bannerText, style: TextStyle(color: Colors.white)),
      ]),
    );
  }

  Widget _promoImage(Reward reward) {
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
        InkWell(
          child: Padding(
            padding: EdgeInsets.all(15.0),
            child: HeartIcon(isHollow: false),
          ),
          onTap: () {},
        )
      ],
    );
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
}
