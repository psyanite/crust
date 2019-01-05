import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchStoresRequest());
          store.dispatch(FetchFavoritesRequest());
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => _Presenter(
              stores: props.stores,
              favoriteStores: props.favoriteStores,
              favoriteStore: props.favoriteStore,
              unfavoriteStore: props.unfavoriteStore,
              isLoggedIn: props.isLoggedIn,
            ));
  }
}

class _Presenter extends StatelessWidget {
  final List<MyStore.Store> stores;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Presenter({Key key, this.stores, this.favoriteStores, this.favoriteStore, this.unfavoriteStore, this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[_appBar(), _content()]);
  }

  Widget _appBar() {
    return SliverAppBar(
        pinned: false,
        floating: false,
        expandedHeight: 55.0,
        backgroundColor: Burnt.primary,
        elevation: 24.0,
        title: Text('Burntoast', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _content() {
    if (stores == null) return LoadingSliver();
    stores.sort((a, b) => a.id.compareTo(b.id));
    return SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        delegate: SliverChildListDelegate(List<Widget>.from(stores.map(_storeCard))));
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)),
            );
          },
          child: Container(
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                Container(height: 100.0, child: Image.network(store.coverImage, fit: BoxFit.cover)),
                _favoriteButton(store),
              ],
            ),
            Padding(
                padding: EdgeInsets.only(left: 8.0, top: 5.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                  Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                ]))
          ])),
        );
      },
    );
  }

  Widget _favoriteButton(MyStore.Store store) {
    return Builder(
      builder: (context) => FavoriteButton(
        padding: 10.0,
        isFavorited: favoriteStores.contains(store.id),
        onFavorite: () {
          if (isLoggedIn) {
            favoriteStore(store.id);
          } else {
            snack(context, 'Please login to favorite store');
          }
        },
        onUnfavorite: () {
          unfavoriteStore(store.id);
        },
      ),
    );
  }
}

class _Props {
  final List<MyStore.Store> stores;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Props({
    this.stores,
    this.favoriteStores,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      stores: store.state.store.stores != null ? store.state.store.stores.values.toList() : null,
      favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
