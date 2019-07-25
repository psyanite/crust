import 'dart:async';

import 'package:crust/components/dialog.dart';
import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/new_post/review_form.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

class StoreScreen extends StatelessWidget {
  final int storeId;

  StoreScreen({Key key, this.storeId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) {
          if (store.state.store.stores == null) {
            store.dispatch(FetchStoreByIdRequest(storeId));
            store.dispatch(FetchPostsByStoreIdRequest(storeId));
          } else {
            store.dispatch(FetchPostsByStoreIdRequest(storeId));
          }
        },
        converter: (Store<AppState> store) => _Props.fromStore(store, storeId),
        builder: (context, props) => _Presenter(
            store: props.store,
            favoriteStores: props.favoriteStores,
            favoriteStore: props.favoriteStore,
            unfavoriteStore: props.unfavoriteStore,
            isLoggedIn: props.isLoggedIn,
            fetchPostsByStoreId: props.fetchPostsByStoreId,
            favoritePosts: props.favoritePosts));
  }
}

class _Presenter extends StatelessWidget {
  final MyStore.Store store;
  final Set<int> favoriteStores;
  final Set<int> favoritePosts;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;
  final Function fetchPostsByStoreId;

  _Presenter(
      {Key key,
      this.store,
      this.favoriteStores,
      this.favoritePosts,
      this.favoriteStore,
      this.unfavoriteStore,
      this.isLoggedIn,
      this.fetchPostsByStoreId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
      onRefresh: _onRefresh,
      child: CustomScrollView(slivers: <Widget>[
        _appBar(),
        PostList(
          noPostsView: Text('Looks like ${store.name} doesn\'t have any posts yet.'),
          posts: store.posts,
          postListType: PostListType.forStore,
        )
      ]),
    ));
  }

  Future<void> _onRefresh() async {
    await fetchPostsByStoreId();
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(children: <Widget>[
          _bannerImage(),
          _metaInfo(),
          _writeAReviewButton()])));
}

  Widget _bannerImage() {
    return Stack(
      alignment: AlignmentDirectional.topStart,
      children: <Widget>[
        Container(
            height: 300.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                image: NetworkImage(store.coverImage),
                fit: BoxFit.cover,
              ),
            )),
        Container(height: 150.0, decoration: BoxDecoration(
          gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0, 0.2, 1.0],
          colors: [Color(0x30000000), Color(0x30000000), Color(0x0000000)],
        ))),
        SafeArea(
          child: Container(
            height: 55.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                BackArrow(color: Colors.white),
                Padding(child: _menuButton(), padding: EdgeInsets.only(right: 10.0))
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _metaInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(store.name, style: Burnt.display4),
              ),
              _favoriteButton()
            ],
          ),
          Text(store.cuisines.join(', '), style: TextStyle(color: Burnt.primary)),
          Container(height: 25.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    InkWell(
                      splashColor: Burnt.splashOrange,
                      highlightColor: Colors.transparent,
                      onTap: () => launch('tel:0${store.phoneNumber}'),
                      child: Row(
                        children: <Widget>[
                          Icon(CrustCons.call_bold, size: 35.0, color: Burnt.iconOrange),
                          Container(width: 10.0),
                          Text('0${store.phoneNumber}', style: TextStyle(color: Burnt.hintTextColor)),
                        ],
                      ),
                    ),
                    Container(height: 10.0),
                    InkWell(
                      splashColor: Burnt.splashOrange,
                      highlightColor: Colors.transparent,
                      onTap: () => launch(store.address.googleUrl),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Icon(CrustCons.location_bold, size: 35.0, color: Burnt.iconOrange),
                          Container(width: 10.0),
                          _addressLong(),
                        ],
                      ),
                    ),
                    Container(height: 5.0),
                  ],
                ),
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
    );
  }

  Widget _writeAReviewButton() {
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: 20.0, left: 16.0, right: 16.0),
        child: InkWell(
          splashColor: Burnt.splashOrange,
          highlightColor: Colors.transparent,
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewForm(store: store))),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Color(0xFFFFD173), width: 1.0, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0)),
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text('Write a review', style: TextStyle(fontSize: 18.0, color: Burnt.primaryTextColor)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _ratingCount(int count, Score score) {
    return Padding(
      padding: EdgeInsets.only(bottom: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10.0),
            child: Text(count != null ? count.toString() : '', style: TextStyle(color: Burnt.lightTextColor)),
          ),
          ScoreIcon(score: score, size: 25.0)
        ],
      ),
    );
  }

  Widget _addressLong() {
    var address = store.address;
    var firstSentence = '';
    if (address.firstLine != null) firstSentence += "${address.firstLine}";
    if (address.secondLine != null) firstSentence += ", ${address.secondLine}";
    var secondSentence = '';
    secondSentence += "${address.streetNumber} ${address.streetName}, ";
    if (store.location != null) secondSentence += "${store.location}";
    if (store.suburb != null) secondSentence += "${store.suburb}";
    return Container(
      padding: EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (firstSentence.isNotEmpty) Text(firstSentence, style: TextStyle(color: Burnt.hintTextColor)),
          if (secondSentence.isNotEmpty) Text(secondSentence, style: TextStyle(color: Burnt.hintTextColor)),
        ],
      ),
    );
  }

  Widget _menuButton() {
    var options = <DialogOption>[
      DialogOption(icon: CrustCons.call_bold, display: 'Call 0${store.phoneNumber}', onTap: () => launch('tel:0${store.phoneNumber}')),
      DialogOption(icon: CrustCons.location_bold, display: 'Get Directions', onTap: () => launch(store.address.googleUrl)),
    ];
    var showBottomSheet = (context) {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, index) => _option(options[index]),
              separatorBuilder: (context, index) => Divider(height: 1.0, color: Color(0x16007AFF)),
              itemCount: options.length)
          );
        }
      );
    };
    return Builder(
      builder: (context) => InkWell(
        onTap: () => showBottomSheet(context),
        child: Icon(CrustCons.menu_bold, color: Colors.white, size: 30.0)));
  }


  Widget _option(DialogOption option) {
    return InkWell(
      splashColor: Burnt.splashOrange,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8.0),
        padding: EdgeInsets.only(left: 40.0),
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(option.icon, size: 35.0, color: Burnt.iconOrange),
            Container(width: 10.0),
            Text(option.display, style: TextStyle(color: Burnt.hintTextColor, fontSize: 17.0))],
        ),
      ),
      onTap: option.onTap);
  }

  Widget _favoriteButton() {
    return Builder(
      builder: (context) => FavoriteButton(
        size: 30.0,
        padding: 0,
        isFavorited: favoriteStores.contains(store.id),
        onFavorite: () {
          if (isLoggedIn) {
            favoriteStore(store.id);
            snack(context, 'Added to favourites');
          } else {
            snack(context, 'Login now to favourite store');
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
  final Set<int> favoritePosts;
  final Function favoriteStore;
  final Function unfavoriteStore;
  final bool isLoggedIn;
  final Function fetchPostsByStoreId;

  _Props(
      {this.store,
      this.favoriteStores,
      this.favoritePosts,
      this.favoriteStore,
      this.unfavoriteStore,
      this.isLoggedIn,
      this.fetchPostsByStoreId});

  static fromStore(Store<AppState> store, int storeId) {
    return _Props(
      store: store.state.store.stores[storeId],
      favoriteStores: store.state.me.favoriteStores ?? Set<int>(),
      favoritePosts: store.state.me.favoritePosts ?? Set<int>(),
      favoriteStore: (storeId) => store.dispatch(FavoriteStoreRequest(storeId)),
      unfavoriteStore: (storeId) => store.dispatch(UnfavoriteStoreRequest(storeId)),
      isLoggedIn: store.state.me.user != null,
      fetchPostsByStoreId: () => store.dispatch(FetchPostsByStoreIdRequest(storeId)),
    );
  }
}
