import 'package:crust/components/search/search_icon.dart';
import 'package:crust/components/stores/stores_grid.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchStoresRequest());
          store.dispatch(FetchFavoritesRequest());
          if (store.state.me.user != null) store.dispatch(FetchMyPostsRequest(store.state.me.user.id));
          store.dispatch(FetchRewardsRequest());
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => _Presenter(
              stores: props.stores,
              favoriteStores: props.favoriteStores,
              favoriteStore: props.favoriteStore,
              unfavoriteStore: props.unfavoriteStore,
              isLoggedIn: props.isLoggedIn,
              error: props.error,
            ));
  }
}

class _Presenter extends StatelessWidget {
  final List<MyStore.Store> stores;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;
  final String error;

  _Presenter({Key key, this.stores, this.favoriteStores, this.favoriteStore, this.unfavoriteStore, this.isLoggedIn, this.error})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(body: CustomScrollView(slivers: <Widget>[_appBar(), StoresGrid(stores: stores)]));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        height: 100.0,
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            Text('BURNTOAST', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
            Text('Burntoast',
                style: TextStyle(
                    color: Burnt.primary, fontSize: 44.0, fontFamily: Burnt.fontFancy, fontWeight: Burnt.fontLight, letterSpacing: 0.0)),
            SearchIcon()
          ],
        ),
      )),
    );
  }
}

class _Props {
  final List<MyStore.Store> stores;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;
  final String error;

  _Props({
    this.stores,
    this.favoriteStores,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
    this.error,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
        stores: store.state.store.stores != null ? store.state.store.stores.values.toList() : null,
        favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
        favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
        unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
        isLoggedIn: store.state.me.user != null,
        error: store.state.error.message);
  }
}
