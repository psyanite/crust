import 'package:crust/components/rewards_screen/reward_cards.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
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
          store.dispatch(FetchRewardsRequested());
          store.dispatch(FetchFavoritesRequest());
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => CustomScrollView(slivers: <Widget>[_appBar(), _content(props)]));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('REWARDS', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
                  _viewModeIcon()
                ],
              ),
              Text('Browse through all available rewards near you')
            ],
          ),
        )
      ),
    );
  }

  Widget _viewModeIcon() {
    return IconButton(
      splashColor: Colors.transparent,
      padding: EdgeInsets.all(0.0),
      icon: Icon(CrustCons.view_mode),
      color: Burnt.lightGrey,
      iconSize: 15.0,
      onPressed: _toggleLayout);
  }

  Widget _content(_Props props) {
    if (props.rewards == null) return LoadingSliver();
    return RewardCards(
        rewards: props.rewards,
        favoriteRewards: props.favoriteRewards,
        favoriteReward: props.favoriteReward,
        unfavoriteReward: props.unfavoriteReward,
        isLoggedIn: props.isLoggedIn,
        layout: currentLayout);
  }

  _toggleLayout() {
    setState(() {
      if (currentLayout == 'card') {
        currentLayout = 'list';
      } else {
        currentLayout = 'card';
      }
    });
  }
}

class _Props {
  final List<Reward> rewards;
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final bool isLoggedIn;

  _Props({
    this.rewards,
    this.favoriteRewards,
    this.favoriteReward,
    this.unfavoriteReward,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      rewards: store.state.reward.rewards != null ? store.state.reward.rewards.values.toList() : null,
      favoriteRewards: store.state.me.favoriteRewards ?? Set<int>(),
      favoriteReward: (rewardId) => store.dispatch(FavoriteRewardRequest(rewardId)),
      unfavoriteReward: (rewardId) => store.dispatch(UnfavoriteRewardRequest(rewardId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
