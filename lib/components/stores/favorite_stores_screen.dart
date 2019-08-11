import 'package:crust/components/stores/stores_grid.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FavoriteStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchFavorites(updateStore: true));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (context, props) => _Presenter(favoriteStores: props.stores));
  }
}

class _Presenter extends StatefulWidget {
  final List<MyStore.Store> favoriteStores;

  _Presenter({Key key, this.favoriteStores}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), StoresGrid(stores: widget.favoriteStores, confirmUnfavorite: true)];
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
            Text('MY FAVOURITES', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
            Padding(
              padding: EdgeInsets.only(top: 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('All your favourited stores'),
                ],
              ),
            )
          ],
        ),
      )),
    );
  }
}

class _Props {
  final List<MyStore.Store> favoriteStores;

  _Props({this.favoriteStores});

  static fromStore(Store<AppState> store) {
    var stores = store.state.store.stores;
    var favoriteStores = store.state.favorite.stores;
    return _Props(
      favoriteStores: stores != null && favoriteStores != null
          ? stores.entries.where((r) => favoriteStores.contains(r.value.id)).map((e) => e.value).toList()
          : null,
    );
  }
}
