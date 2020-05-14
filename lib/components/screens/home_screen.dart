import 'dart:async';

import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/stores/favorite_store_button.dart';
import 'package:crust/components/stores/search_stores_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_service.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  final Function jumpToStoresTab;

  HomeScreen({Key key, this.jumpToStoresTab}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          myId: props.myId,
          feed: props.posts,
          topStores: props.topStores,
          refresh: props.refresh,
          removePost: props.removePost,
          addPosts: props.addPosts,
          jumpToStoresTab: jumpToStoresTab,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final List<Post> feed;
  final List<MyStore.Store> topStores;
  final Function refresh;
  final Function removePost;
  final Function addPosts;
  final Function jumpToStoresTab;

  _Presenter({Key key, this.myId, this.refresh, this.feed, this.topStores, this.removePost, this.addPosts, this.jumpToStoresTab}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  FeedService feedService = const FeedService();
  ScrollController _scrollie;
  bool _loading = false;
  int _limit = 12;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (widget.feed.isNotEmpty && _loading == false && _limit > 0 && _scrollie.position.extentAfter < 500) _getMore();
      });
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.feed.length != widget.feed.length) {
      _loading = false;
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    this.setState(() {
      _limit = 12;
      _loading = true;
    });
    widget.refresh();
    await Future.delayed(Duration(milliseconds: 500));
  }

  Future<List<Post>> _fetchMore() {
    if (widget.myId != null) {
      return feedService.fetchFeed(userId: widget.myId, limit: _limit, offset: widget.feed.length);
    } else {
      return feedService.fetchDefaultFeed(limit: _limit, offset: widget.feed.length);
    }
  }

  _getMore() async {
    this.setState(() => _loading = true);
    var fresh = await _fetchMore();
    if (fresh.length < _limit) {
      this.setState(() {
        _limit = 0;
        _loading = false;
      });
    }
    if (fresh.isNotEmpty) widget.addPosts(fresh);
  }

  removeFromList(index, postId) => widget.removePost(postId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(),
            _topStores(context),
            _separator(),
            PostList(
              noPostsView: Container(),
              posts: widget.feed,
              postListType: PostListType.forFeed,
              removeFromList: (i, postId) => widget.removePost(postId),
            ),
            if (_loading) LoadingSliver(),
          ],
          key: PageStorageKey('Home'),
          controller: _scrollie,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }

  Widget _separator() {
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
      ),
    );
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 100.0,
          padding: EdgeInsets.only(left: 16.0, right: 6.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Burntoast',
                style: TextStyle(
                  color: Burnt.primary,
                  fontSize: 44.0,
                  fontFamily: Burnt.fontFancy,
                  fontWeight: Burnt.fontLight,
                  letterSpacing: 0.0,
                ),
              ),
              Row(children: <Widget>[_searchIcon(), _qrIcon()])
            ],
          ),
        ),
      ),
    );
  }

  Widget _topStores(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(height: 20.0),
          Text('HOT SPOTS 🔥', style: Burnt.appBarTitleStyle.copyWith(color: Burnt.hintTextColor)),
          Container(height: 15.0),
          Container(
            height: 270.0,
            child: Swiper(
              loop: false,
              containerHeight: 200.0,
              itemBuilder: (BuildContext context, int i) {
                return Stack(
                  children: <Widget>[
                    Container(height: 200.0),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        boxShadow: [BoxShadow(color: Color(0x10000000), offset: Offset(2.0, 2.0), blurRadius: 1.0, spreadRadius: 1.0)],
                      ),
                      child: _topStoreCard(widget.topStores[i]),
                    ),
                  ],
                );
              },
              itemCount: widget.topStores.length,
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: HollowButton(
              padding: 8.0,
              onTap: widget.jumpToStoresTab,
              children: <Widget>[
                Text('More Places to Eat and Drink', style: TextStyle(fontSize: 18.0, color: Burnt.primaryTextColor)),
              ],
            ),
          ),
          Container(height: 50.0),
        ],
      ),
    );
  }

  Widget _topStoreCard(MyStore.Store store) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Stack(
              alignment: AlignmentDirectional.topEnd,
              children: <Widget>[
                NetworkImg(store.coverImage, height: 150.0),
                FavoriteStoreButton(store: store, size: 30.0, padding: EdgeInsets.all(20.0)),
              ],
            ),
            Container(
              padding: EdgeInsets.only(top: 16.0, bottom: 20.0, left: 16.0, right: 16.0),
              child: Column(
                children: <Widget>[
                  Text(store.name, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
                  Text(store.location ?? store.suburb, overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0)),
                  Text(store.cuisines.join(', '), overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _searchIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 21.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
      );
    });
  }

  Widget _qrIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.qr, color: Color(0x50604B41), size: 23.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQrScreen())),
      );
    });
  }
}

class _Props {
  final int myId;
  final List<Post> posts;
  final List<MyStore.Store> topStores;
  final Function refresh;
  final Function removePost;
  final Function addPosts;

  _Props({
    this.myId,
    this.posts,
    this.topStores,
    this.refresh,
    this.removePost,
    this.addPosts,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      myId: store.state.me.user?.id,
      posts: store.state.feed.posts.values.toList(),
      topStores: store.state.store.topStores.values.toList(),
      refresh: () {
        store.dispatch(FetchTopStores());
        store.dispatch(InitFeed());
      },
      removePost: (postId) => store.dispatch(RemoveFeedPost(postId)),
      addPosts: (posts) => store.dispatch(FetchFeedSuccess(posts)),
    );
  }
}
