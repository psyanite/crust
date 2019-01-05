import 'package:crust/components/screens/store_screen.dart';
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
    return Scaffold(appBar: _appBar(), body: _content());
  }

  Widget _appBar() {
    return AppBar(
        backgroundColor: Burnt.primary,
        elevation: 0.0,
        title: Text('Favourites', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _content() {
    if (!isLoggedIn) return _loginMessage();
    if (rewards == null && stores == null) return LoadingCenter();
    return Column(
      children: <Widget>[
        _list("Favourite Stores", () {}, List<Widget>.from(stores.map(_storeCard))),
        _list("Favourite Rewards", () {}, List<Widget>.from(rewards.map(_rewardCard))),
      ],
    );
  }

  Widget _loginMessage() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[Text("Login now to see your favorites!")],
    ));
  }

  Widget _list(String title, Function onTap, List<Widget> children) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 5.0, left: 15.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 23.0, fontWeight: Burnt.fontBold)),
              InkWell(child: Text("See All", style: TextStyle(fontSize: 14.0, fontWeight: Burnt.fontBold, color: Burnt.primary)), onTap: onTap)
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 15.0),
          height: 180.0,
          child: ListView(scrollDirection: Axis.horizontal, children: children))
      ],
    );
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(builder: (context) {
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)),
            );
          },
          child: Container(
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.only(right: 10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(height: 100.0, child: Image.network(store.coverImage, fit: BoxFit.cover)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Container(height: 5.0),
                  Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                  Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                ])
              ])));
    });
  }

  Widget _rewardCard(Reward reward) {
    return Builder(builder: (context) {
      return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreScreen(storeId: 1)),
            );
          },
          child: Container(
              width: 200.0,
              height: 200.0,
              padding: EdgeInsets.only(right: 10.0),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(height: 100.0, child: Image.network(reward.promoImage, fit: BoxFit.cover)),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Container(height: 5.0),
                  Text(reward.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text(reward.locationText(), style: TextStyle(fontSize: 14.0)),
                ])
              ])));
    });
  }

//  Widget _favoriteButton(MyStore.Store store) {
//    return Builder(
//      builder: (context) => FavoriteButton(
//        padding: 10.0,
//        isFavorited: favoriteStores.contains(store.id),
//        onFavorite: () {
//          if (isLoggedIn) {
//            favoriteStore(store.id);
//          } else {
//            snack(context, 'Please login to favorite store');
//          }
//        },
//        onUnfavorite: () {
//          unfavoriteStore(store.id);
//        },
//      ),
//    );
//  }
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
    var favoriteRewards = store.state.me.favoriteRewards.take(5);
    var favoriteStores = store.state.me.favoriteStores.take(5);
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
