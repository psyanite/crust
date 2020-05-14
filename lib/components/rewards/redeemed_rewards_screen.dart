import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RedeemedRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) {
        store.dispatch(FetchRedeemedRewards());
      },
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) => _Presenter(myId: props.myId, redeemed: props.redeemed),
    );
  }
}

class _Presenter extends StatelessWidget {
  final int myId;
  final List<UserReward> redeemed;

  _Presenter({Key key, this.myId, this.redeemed}) : super(key: key);

  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), _content()];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
                ],
              ),
              Text('REDEEMED REWARDS', style: Burnt.appBarTitleStyle),
              if (redeemed != null && redeemed.isNotEmpty) Text('All the rewards you\'ve redeemed in the past')
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    if (redeemed.isEmpty) return _noRewards();
    return RewardCards(rewards: redeemed.map((u) => u.reward));
  }

  Widget _noRewards() {
    return CenterTextSliver(text: 'Looks like you haven\'t redeemed any rewards yet.\nDon\'t miss out!');
  }
}

class _Props {
  final int myId;
  final List<UserReward> redeemed;

  _Props({this.myId, this.redeemed});

  static fromStore(Store<AppState> store) {
    var me = store.state.me.user;
    return _Props(
      myId: me != null ? me.id : 0,
      redeemed: store.state.reward.redeemed,
    );
  }
}
