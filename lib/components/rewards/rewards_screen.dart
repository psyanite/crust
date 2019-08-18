import 'package:crust/components/rewards/favorite_rewards_screen.dart';
import 'package:crust/components/rewards/redeemed_rewards_screen.dart';
import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/rewards/view_mode_icon.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RewardsScreen extends StatefulWidget {
  @override
  RewardsScreenState createState() => RewardsScreenState();
}

class RewardsScreenState extends State<RewardsScreen> {
  String currentLayout = 'card';

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchRewards());
          store.dispatch(FetchFavorites());
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => CustomScrollView(slivers: <Widget>[
              _appBar(),
              _seeRedeemedButton(context, props.isLoggedIn),
              _myRewardsButton(context, props.isLoggedIn),
              _rewardsListTitle(),
              _rewardsList(props)
            ]));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 33.0, bottom: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[Text('REWARDS', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)), _qrIcon()],
            ),
          ],
        ),
      )),
    );
  }

  Widget _qrIcon() {
    return Builder(
        builder: (context) => IconButton(
            icon: Icon(CrustCons.qr, color: Color(0x50604B41), size: 23.0),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQrScreen()));
            }));
  }

  Widget _seeRedeemedButton(BuildContext context, bool isLoggedIn) {
    var onTap = () {
      if (!isLoggedIn) {
        snack(context, 'Login now to redeem rewards!');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RedeemedRewardsScreen()));
      }
    };
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: HollowButton(padding: 8.0, onTap: onTap, children: <Widget>[
          Icon(CrustCons.present, color: Burnt.primaryTextColor, size: 25.0),
          Container(width: 8.0),
          Text('View Redeemed Rewards', style: TextStyle(fontSize: 20.0, color: Burnt.primaryTextColor)),
        ]),
      ),
    );
  }

  Widget _myRewardsButton(BuildContext context, bool isLoggedIn) {
    return SliverToBoxAdapter(
        child: Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 15.0, left: 16.0, right: 16.0),
      child: BurntButton(
        icon: CrustCons.heart,
        iconSize: 25.0,
        text: 'View My Favourites',
        padding: 10.0,
        fontSize: 20.0,
        onPressed: () {
          if (!isLoggedIn) {
            snack(context, 'Login now to favourite rewards!');
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteRewardsScreen()));
          }
        },
      ),
    ));
  }

  Widget _rewardsListTitle() {
    return SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.only(top: 25.0, left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Rewards near you'),
                ViewModeIcon(toggleLayout: () {
                  setState(() {
                    if (currentLayout == 'card') {
                      currentLayout = 'list';
                    } else {
                      currentLayout = 'card';
                    }
                  });
                })
              ],
            )));
  }

  Widget _rewardsList(_Props props) {
    if (props.rewards.isEmpty) return LoadingSliver();
    return RewardCards(rewards: props.rewards, layout: currentLayout);
  }
}

class _Props {
  final List<Reward> rewards;
  final bool isLoggedIn;

  _Props({
    this.rewards,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    var rewards = store.state.reward.rewards.values.toList();
    return _Props(
      rewards: rewards.where((r) => r.isExpired() == false && r.isHidden() == false).toList(),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
