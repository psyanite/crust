import 'package:crust/components/rewards/favorite_rewards_screen.dart';
import 'package:crust/components/rewards/rewards_side_scroller.dart';
import 'package:crust/components/stores/favorite_stores_screen.dart';
import 'package:crust/components/stores/stores_side_scroller.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchFavorites(updateStore: true));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => _Presenter(
              rewards: props.rewards,
              stores: props.stores,
              favoriteReward: props.favoriteReward,
              unfavoriteReward: props.unfavoriteReward,
              favoriteStore: props.favoriteStore,
              unfavoriteStore: props.unfavoriteStore,
              isLoggedIn: props.isLoggedIn,
            ));
  }
}

class _Presenter extends StatelessWidget {
  final List<Reward> rewards;
  final List<MyStore.Store> stores;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.rewards,
      this.stores,
      this.favoriteReward,
      this.unfavoriteReward,
      this.favoriteStore,
      this.unfavoriteStore,
      this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[_appBar(), _content(context)]);
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('FAVOURITES', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
                Container(height: 50, width: 50),
              ],
            ),
            Text('All your favourited stores and rewards')
          ],
        ),
      )),
    );
  }

  Widget _content(BuildContext context) {
    if (!isLoggedIn) return CenterTextSliver(text: 'Login now to see your favorites!');
    if (rewards == null && stores == null) return LoadingSliver();
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        StoresSideScroller(
          stores: stores,
          title: 'Favourite Stores',
          emptyMessage: 'Start favouriting stores and they\'ll show up here.',
          seeAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteStoresScreen())),
          confirmUnfavorite: true,
        ),
        RewardsSideScroller(
          rewards: rewards,
          title: 'Favourite Rewards',
          emptyMessage: 'Start favouriting rewards and they\'ll show up here.',
          seeAll: () => Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteRewardsScreen())),
          showExpiredBanner: true,
          confirmUnfavorite: true,
        )
      ]),
    );
  }
}

class _Props {
  final List<Reward> rewards;
  final List<MyStore.Store> stores;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Props({
    this.rewards,
    this.stores,
    this.favoriteReward,
    this.unfavoriteReward,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    var stores = store.state.store.stores;
    var rewards = store.state.reward.rewards;
    var favoriteRewards = store.state.me.favoriteRewards?.take(5);
    var favoriteStores = store.state.me.favoriteStores?.take(5);
    return _Props(
      rewards: rewards != null && favoriteRewards != null
          ? rewards.entries.where((r) => favoriteRewards.contains(r.value.id)).map((e) => e.value).toList()
          : null,
      stores: stores != null && favoriteStores != null
          ? stores.entries.where((s) => favoriteStores.contains(s.value.id)).map((e) => e.value).toList()
          : null,
      favoriteReward: (rewardId) => store.dispatch(FavoriteReward(rewardId)),
      unfavoriteReward: (rewardId) => store.dispatch(UnfavoriteReward(rewardId)),
      favoriteStore: (storeId) => store.dispatch(FavoriteStore(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStore(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
