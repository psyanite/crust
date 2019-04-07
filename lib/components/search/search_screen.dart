import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SearchScreen extends SearchDelegate<MyStore.Store> {

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(CrustCons.back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Column();
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<List<MyStore.Store>>(
      future: SearchService.searchStores(query),
      builder: (context, AsyncSnapshot<List<MyStore.Store>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Press button to start.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingCenter();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.data.isEmpty) {
              return Text("No Results Found.");
            }
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, i) {
                return _ResultCard(store: snapshot.data[i]);
              },
            );
        }
        return null; // unreachable
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final MyStore.Store store;

  const _ResultCard({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => _Presenter(
              store: store,
              favoriteStores: props.favoriteStores,
              favoriteStore: props.favoriteStore,
              unfavoriteStore: props.unfavoriteStore,
              isLoggedIn: props.isLoggedIn,
            ));
  }
}

class _Presenter extends StatelessWidget {
  final MyStore.Store store;
  final SearchDelegate<MyStore.Store> searchDelegate;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Presenter({Key key, this.store, this.searchDelegate, this.favoriteStores, this.favoriteStore, this.unfavoriteStore, this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
        child: Container(
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                _listItemPromoImage(store),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                        Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                        Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    _ratingCount(store.heartCount, Score.good),
                    _ratingCount(store.burntCount, Score.bad),
                  ],
                )
              ],
            ),
          ),
        ),
      ));

  Widget _ratingCount(int count, Score score) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 3.0),
            child: Text(count != null ? count.toString() : '', style: TextStyle(fontSize: 12.0)),
          ),
          ScoreIcon(score: score, size: 25.0)
        ],
      ),
    );
  }

  Widget _listItemPromoImage(MyStore.Store store) {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
            width: 120.0,
            height: 100.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                image: NetworkImage(store.coverImage),
                fit: BoxFit.cover,
              ),
            )),
        _favoriteButton(store)
      ],
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
                snack(context, 'Added to favourites');
              } else {
                snack(context, 'Please login to favourite store');
              }
            },
            onUnfavorite: () {
              unfavoriteStore(store.id);
              snack(context, 'Removed from favourites');
            },
          ),
    );
  }
}

class _Props {
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Props({
    this.favoriteStores,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
