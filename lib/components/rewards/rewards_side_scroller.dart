import 'package:crust/components/rewards/more_rewards_screen.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RewardsSideScroller extends StatelessWidget {
  final List<UserReward> userRewards;
  final List<Reward> rewards;
  final String title;
  final String description;
  final String emptyMessage;
  final bool showExpiredBanner;

  RewardsSideScroller({Key key, this.userRewards, this.rewards, this.title, this.description, this.emptyMessage, this.showExpiredBanner = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (context, props) => _Presenter(
              userRewards: userRewards,
              rewards: rewards,
              title: title,
              description: description,
              emptyMessage: emptyMessage,
              showExpiredBanner: showExpiredBanner));
  }
}

class _Presenter extends StatelessWidget {
  final List<UserReward> userRewards;
  final List<Reward> rewards;
  final String title;
  final String description;
  final String emptyMessage;
  final bool showExpiredBanner;

  _Presenter({Key key, this.userRewards, this.rewards, this.title, this.description, this.emptyMessage, this.showExpiredBanner}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (rewards != null) {
      if (rewards.isEmpty) return Container();
      var seeAll = () {
        Navigator.push(
            context, MaterialPageRoute(builder: (_) => MoreRewardsScreen(title: title, description: description, rewards: rewards)));
      };
      var widgets = List<Widget>.from(rewards.take(3).map((r) {
        var onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(rewardId: r.id)));
        return _card(onTap, r);
      }));
      return _list(widgets, seeAll);
    } else {
      if (userRewards.isEmpty) return Container();
      var seeAll = () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => MoreRewardsScreen(title: title, description: description, rewards: userRewards.map((u) => u.reward))));
      };
      var widgets = List<Widget>.from(userRewards.take(3).map((u) {
        var onTap = () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardScreen(userReward: u)));
        return _card(onTap, u.reward);
      }));
      return _list(widgets, seeAll);
    }
  }

  Widget _list(List<Widget> children, Function seeAll) {
    var showSeeAll = rewards != null ? rewards.length > 3 : userRewards != null ? userRewards.length > 3 : false;
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 23.0, fontWeight: Burnt.fontBold)),
              if (showSeeAll)
                InkWell(
                    child: Text('See All', style: TextStyle(fontSize: 14.0, fontWeight: Burnt.fontBold, color: Burnt.primary)),
                    onTap: seeAll)
            ],
          ),
        ),
        Container(margin: EdgeInsets.only(left: 16.0), height: 180.0, child: ListView(scrollDirection: Axis.horizontal, children: children))
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
                  Stack(alignment: AlignmentDirectional.bottomCenter, children: <Widget>[
                    Container(
                        height: 100.0,
                        width: 200.0,
                        padding: EdgeInsets.all(1.0),
                        color: Burnt.imgPlaceholderColor,
                        child: Image.network(reward.promoImage, fit: BoxFit.cover)),
                    if (showExpiredBanner == true && reward.isExpired() == true) Container(
                      width: 200.0,
                      padding: EdgeInsets.symmetric(vertical: 7.0),
                      color: Burnt.separator,
                      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Expired', style: TextStyle(color: Burnt.lightTextColor)),
                      ]),
                    )
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(height: 5.0),
                    Text(reward.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text(reward.locationText(), style: TextStyle(fontSize: 14.0)),
                  ])
                ]))));
  }
}

class _Props {
  final bool isLoggedIn;

  _Props({
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
    );
  }
}
