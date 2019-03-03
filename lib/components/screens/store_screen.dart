import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/post_list.dart';
import 'package:crust/models/post.dart';
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

class StoreScreen extends StatelessWidget {
  final int storeId;

  StoreScreen({Key key, this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) {
          if (store.state.store.stores[storeId].posts == null) return store.dispatch(FetchPostsByStoreIdRequest(storeId));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store, storeId),
        builder: (context, props) => _Presenter(
          store: props.store,
          favoriteStores: props.favoriteStores,
          favoriteStore: props.favoriteStore,
          unfavoriteStore: props.unfavoriteStore,
          isLoggedIn: props.isLoggedIn
        ));
  }
}

class _Presenter extends StatelessWidget {
  final MyStore.Store store;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Presenter({Key key, this.store, this.favoriteStores,  this.favoriteStore, this.unfavoriteStore, this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[_appBar(), PostList(noPostsView: Text('Looks like ${store.name} hasn\'t posted anything yet.'), posts: store.posts, postListType: PostListType.forStore)]));
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
        child: Container(
            child: Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color: Burnt.imgPlaceholderColor,
                  image: DecorationImage(
                    image: NetworkImage(store.coverImage),
                    fit: BoxFit.cover,
                  ),
                )),
            SafeArea(
              child: Container(
                height: 55.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BackArrow(color: Colors.white),
                    Padding(child: _favoriteButton(store), padding: EdgeInsets.only(right: 10.0))
                  ],
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(store.name, style: Burnt.display4),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[Icon(CupertinoIcons.phone), Text(store.phoneNumber)]),
                      Row(children: <Widget>[Icon(CupertinoIcons.person), Text(store.cuisines.join(', '))]),
                      Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[Icon(CupertinoIcons.location), _address()])
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      _ratingCount(store.heartCount, Score.good),
                      _ratingCount(store.okayCount, Score.okay),
                      _ratingCount(store.burntCount, Score.bad),
                    ],
                  )
                ],
              )
            ],
          ),
        ),
      ],
    )));
  }

  Widget _ratingCount(int count, Score score) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(count != null ? count.toString() : ''),
          ),
          ScoreIcon(score: score, size: 25.0)
        ],
      ),
    );
  }

  Widget _address() {
    var children = <Widget>[];
    store.address.firstLine != null ?? children.add(Text(store.address.firstLine));
    store.address.secondLine != null ?? children.add(Text(store.address.secondLine));
    children.add(Text("${store.address.streetNumber} ${store.address.streetName}"));
    children.add(Text(store.location ?? store.suburb));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children,
    );
  }

  Widget _favoriteButton(MyStore.Store store) {
    return Builder(
      builder: (context) => FavoriteButton(
        padding: 0,
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
  final MyStore.Store store;
  final Set<int> favoriteStores;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;

  _Props({
    this.store,
    this.favoriteStores,
    this.favoriteStore,
    this.unfavoriteStore,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store, int storeId) {
    return _Props(
      store: store.state.store.stores[storeId],
      favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
