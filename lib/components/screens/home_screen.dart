import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/stores/browse_stores_screen.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/components/stores/search_stores_screen.dart';
import 'package:crust/components/stores/favorite_store_button.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_service.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          myId: props.myId,
          refresh: props.refresh,
          posts: props.posts,
          topStores: props.topStores,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final Function refresh;
  final List<Post> posts;
  final List<MyStore.Store> topStores;

  _Presenter({Key key, this.myId, this.refresh, this.posts, this.topStores}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie;
  List<Post> posts;
  bool loading = false;
  int limit = 12;
  int offset = 12;
  FeedService feedService = const FeedService();

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (loading == false && limit > 0 && _scrollie.position.extentAfter < 500) _getMorePosts();
      });
    this.setState(() => posts = widget.posts);
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.posts != widget.posts) {
      posts = widget.posts;
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  removeFromList(int index) {
    this.setState(() => posts = List<Post>.from(posts)..removeAt(index));
  }

  Future<List<Post>> _getPosts() async {
    if (widget.myId != null) {
      return feedService.fetchFeed(userId: widget.myId, limit: limit, offset: offset);
    } else {
      return feedService.fetchDefaultFeed(limit: limit, offset: offset);
    }
  }

  _getMorePosts() async {
    this.setState(() => loading = true);
    var fresh = await _getPosts();
    if (fresh.isEmpty) {
      this.setState(() {
        limit = 0;
        loading = false;
      });
      return;
    }
    this.setState(() {
      offset = offset + limit;
      posts = List<Post>.from(posts)..addAll(fresh);
      loading = false;
    });
  }

  Future<void> _refresh() async {
    widget.refresh();
    await Future.delayed(Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(slivers: <Widget>[
          _appBar(),
          _topStores(context),
          _separator(),
          PostList(
            noPostsView: Container(),
            posts: posts,
            postListType: PostListType.forStore,
            removeFromList: removeFromList,
          ),
          if (loading) LoadingSliver(),
        ], controller: _scrollie, physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics())),
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
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BrowseStoresScreen())),
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
                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Burnt.imgPlaceholderColor,
                    image: DecorationImage(
                      image: NetworkImage(store.coverImage),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
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
  final Function refresh;
  final List<Post> posts;
  final List<MyStore.Store> topStores;

  _Props({
    this.myId,
    this.refresh,
    this.posts,
    this.topStores,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      myId: store.state.me.user?.id,
      refresh: () {
        store.dispatch(FetchTopStores());
        store.dispatch(FetchFeed());
      },
      posts: store.state.feed.posts.toList(),
      topStores: store.state.store.topStores.values.toList(),
    );
  }
}
