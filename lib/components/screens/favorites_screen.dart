import 'package:crust/components/confirm.dart';
import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/rewards/favorite_rewards_screen.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/components/stores/favorite_stores_screen.dart';
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
          store.dispatch(FetchFavoritesRequest(updateStore: true));
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
    var storeCards = stores != null ? List<Widget>.from(stores.take(5).map(_storeCard)) : List<Widget>();
    var rewardCards = rewards != null ? List<Widget>.from(rewards.take(5).map(_rewardCard)) : List<Widget>();
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        _list("Favourite Stores", () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteStoresScreen()));
        }, storeCards),
        _list("Favourite Rewards", () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteRewardsScreen()));
        }, rewardCards),
      ]),
    );
  }

  Widget _list(String title, Function onTap, List<Widget> children) {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 10.0),
              child: Text(title, style: TextStyle(fontSize: 23.0, fontWeight: Burnt.fontBold)),
            ),
            InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 16.0, bottom: 10.0, top: 10.0),
                  child: Text('See All', style: TextStyle(fontSize: 14.0, fontWeight: Burnt.fontBold, color: Burnt.primary)),
                ),
                onTap: onTap)
          ],
        ),
        Container(
            margin: EdgeInsets.only(left: 16.0, bottom: 20.0),
            height: 160.0,
            child: ListView(scrollDirection: Axis.horizontal, children: children))
      ],
    );
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(
        builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)),
              );
            },
            child: Container(
                width: 200.0,
                height: 160.0,
                padding: EdgeInsets.only(right: 10.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
                    Container(height: 100.0, width: 200.0, child: Image.network(store.coverImage, fit: BoxFit.cover)),
                    _favoriteButton('Remove Store', 'This store will be removed from favourites', () => unfavoriteReward(store.id))
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(height: 5.0),
                    Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                    Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                  ])
                ]))));
  }

  Widget _rewardCard(Reward reward) {
    return Builder(
        builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => RewardScreen(rewardId: reward.id)),
              );
            },
            child: Container(
                width: 200.0,
                height: 160.0,
                padding: EdgeInsets.only(right: 10.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
                    Container(
                        height: 100.0,
                        width: 200.0,
                        color: Burnt.imgPlaceholderColor,
                        child: Image.network(reward.promoImage, fit: BoxFit.cover)),
                    _favoriteButton('Remove Reward', 'This reward will be removed from favourites', () => unfavoriteReward(reward.id))
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(height: 5.0),
                    Text(reward.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text(reward.locationText(), style: TextStyle(fontSize: 14.0)),
                  ])
                ]))));
  }

  Widget _favoriteButton(String title, String description, Function onConfirm) {
    return Builder(
      builder: (context) => FavoriteButton(
            padding: EdgeInsets.all(7.0),
            isFavorited: true,
            onUnfavorite: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Confirm(
                        title: title,
                        description: description,
                        action: 'Remove',
                        onTap: () {
                          onConfirm();
                          Navigator.of(context, rootNavigator: true).pop(true);
                        });
                  });
            },
          ),
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
      favoriteReward: (rewardId) => store.dispatch(FavoriteRewardRequest(rewardId)),
      unfavoriteReward: (rewardId) => store.dispatch(UnfavoriteRewardRequest(rewardId)),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
