import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:intl/intl.dart';
import 'package:redux/redux.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Reward>>(
        onInit: (Store<AppState> store) => store.dispatch(FetchRewardsRequested()),
        converter: (Store<AppState> store) => store.state.reward.rewards,
        builder: (BuildContext context, List<Reward> rewards) =>
            CustomScrollView(slivers: <Widget>[_appBar(), rewards == null ? LoadingSliver() : _rewardCards(rewards)]));
  }

  Widget _appBar() {
    return SliverAppBar(
        pinned: false,
        floating: false,
        expandedHeight: 60.0,
        backgroundColor: Burnt.primary,
        elevation: 24.0,
        title: Text('Rewards', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _rewardCards(List<Reward> rewards) {
    return SliverList(
      delegate: SliverChildListDelegate(List<Widget>.from(rewards.map(_rewardCard))),
    );
  }

  Widget _rewardCard(Reward reward) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
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
      color: Burnt.primary,
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          child: Text(bannerText, style: TextStyle(color: Colors.white)),
          padding: EdgeInsets.symmetric(vertical: 7.0),
        )
      ]),
    );
  }

  Widget _promoImage(Reward reward) {
    return Container(
        height: 200.0,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(reward.promoImage),
            fit: BoxFit.cover,
          ),
        ));
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
