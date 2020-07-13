import 'package:crust/components/dialog/dialog.dart';
import 'package:crust/components/new_post/write_a_review_screen.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/rewards/reward_swiper.dart';
import 'package:crust/components/stores/favorite_store_button.dart';
import 'package:crust/components/stores/follow_store_button.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:crust/state/store/store_service.dart';
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
        var stores = store.state.store.stores;
        if (stores == null || stores[storeId] == null) {
          store.dispatch(FetchStoreById(storeId));
        }
        store.dispatch(FetchRewardsByStoreId(storeId));
      },
      converter: (Store<AppState> store) => _Props.fromStore(store, storeId),
      builder: (context, props) {
        return _Presenter(
          storeId: storeId,
          store: props.store,
          isLoggedIn: props.isLoggedIn,
          rewards: props.rewards,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final int storeId;
  final MyStore.Store store;
  final bool isLoggedIn;
  final List<Reward> rewards;

  _Presenter({Key key, this.storeId, this.store, this.isLoggedIn, this.rewards}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie;
  List<Post> _posts;
  bool _loading = false;
  int _limit = 12;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (_loading == false && _limit > 0 && _scrollie.position.extentAfter < 500) _getMorePosts();
      });
    _load();
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _load() async {
    var fresh = await _getPosts();
    this.setState(() => _posts = fresh);
  }

  removeFromList(index, postId) {
    this.setState(() => _posts = List<Post>.from(_posts)..removeAt(index));
  }

  Future<List<Post>> _getPosts() async {
    var offset = _posts != null ? _posts.length : 0;
    return StoreService.fetchPostsByStoreId(storeId: widget.storeId, limit: _limit, offset: offset);
  }

  _getMorePosts() async {
    this.setState(() => _loading = true);
    var fresh = await _getPosts();
    if (fresh.length < _limit) {
      this.setState(() {
        _limit = 0;
        _loading = false;
      });
    }
    if (fresh.isNotEmpty) {
      var update = List<Post>.from(_posts)..addAll(fresh);
      this.setState(() {
        _posts = update;
        _loading = false;
      });
    }
  }

  Future<void> _refresh() async {
    var fresh = await StoreService.fetchPostsByStoreId(storeId: widget.storeId, limit: 12, offset: 0);
    this.setState(() {
      _limit = 12;
      _posts = fresh;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.store == null) return Scaffold(body: LoadingCenter());
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        displacement: 30.0,
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(),
            if (widget.rewards.isNotEmpty) _rewards(context),
            PostList(
              noPostsView: Text('Looks like ${widget.store.name} doesn\'t have any reviews yet.'),
              postListType: PostListType.forStore,
              posts: _posts,
              removeFromList: removeFromList,
            ),
            if (_loading == true) LoadingSliver(),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(children: <Widget>[
          _bannerImage(),
          _metaInfo(),
          _buttons(),
          Container(
            margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
          )
        ]),
      ),
    );
  }

  Widget _bannerImage() {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        NetworkImg(widget.store.coverImage, height: 400.0),
        Container(
          height: 400.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.8],
              colors: [Color(0x00000000), Color(0x30000000)],
            ),
          ),
        ),
        SafeArea(
          child: Container(
            height: 60.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[BackArrow(color: Colors.white), Padding(child: _menuButton(), padding: EdgeInsets.only(right: 10.0))],
            ),
          ),
        ),
      ],
    );
  }

  Widget _metaInfo() {
    var store = widget.store;
    return Padding(
      padding: EdgeInsets.only(top: 30.0, bottom: 40.0, left: 16.0, right: 16.0),
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
              FavoriteStoreButton(store: store, size: 30.0),
            ],
          ),
          Text(store.cuisines.join(', '), style: TextStyle(color: Burnt.primary)),
          Container(height: 35.0),
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
                      onTap: () => launch('tel:${store.phoneNumber}'),
                      child: Row(
                        children: <Widget>[
                          Icon(CrustCons.call_bold, size: 35.0, color: Burnt.iconOrange),
                          Container(width: 10.0),
                          Text(store.phoneNumber, style: TextStyle(color: Burnt.hintTextColor)),
                        ],
                      ),
                    ),
                    Container(height: 10.0),
                    InkWell(
                      splashColor: Burnt.splashOrange,
                      highlightColor: Colors.transparent,
                      onTap: () => launch(store.getDirectionUrl()),
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

  Widget _buttons() {
    return Builder(builder: (context) {
      return Container(
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Container(width: 16.0),
            _followButton(context),
            Container(width: 10.0),
            _writeReviewButton(context),
            Container(width: 16.0),
          ],
        ),
      );
    });
  }

  Widget _followButton(BuildContext context) {
    var store = widget.store;
    return Expanded(
      child: FollowStoreButton(
        storeId: store.id,
        storeName: store.name,
        followView: BurntButton(padding: 10.5, text: 'Follow', fontSize: 18.0),
        followedView: SolidButton(
          color: Color(0x10604B41),
          children: <Widget>[Text('Following', style: TextStyle(fontSize: 18.0, color: Burnt.lightTextColor))],
        ),
      ),
    );
  }

  Widget _writeReviewButton(BuildContext context) {
    return Expanded(
      child: HollowButton(
        onTap: () {
          if (widget.isLoggedIn == false) {
            loginSnack(context, 'Login now to write a review');
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (_) => WriteAReviewScreen(store: widget.store)));
          }
        },
        children: <Widget>[
          Text('Write a review', style: TextStyle(fontSize: 18.0, color: Burnt.primaryTextColor)),
        ],
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
    var store = widget.store;
    var first = store.getFirstLine();
    var second = store.getSecondLine();
    return Flexible(
      child: Container(
        padding: EdgeInsets.only(right: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (first.isNotEmpty) Text(first, style: TextStyle(color: Burnt.hintTextColor)),
            if (second.isNotEmpty) Text(second, style: TextStyle(color: Burnt.hintTextColor)),
          ],
        ),
      ),
    );
  }

  Widget _menuButton() {
    var store = widget.store;
    var options = <DialogOption>[
      DialogOption(icon: CrustCons.call_bold, display: 'Call ${store.phoneNumber}', onTap: () => launch('tel:${store.phoneNumber}')),
      DialogOption(icon: CrustCons.location_bold, display: 'Get Directions', onTap: () => launch(store.getDirectionUrl())),
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
              separatorBuilder: (context, index) => Divider(height: 1.0, color: Burnt.separatorBlue),
              itemCount: options.length,
            ),
          );
        },
      );
    };
    return Builder(builder: (context) {
      return InkWell(onTap: () => showBottomSheet(context), child: Icon(CrustCons.triple_dot, color: Colors.white, size: 30.0));
    });
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
            Text(option.display, style: TextStyle(color: Burnt.hintTextColor, fontSize: 17.0))
          ],
        ),
      ),
      onTap: option.onTap,
    );
  }

  Widget _rewards(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        child: Column(
          children: <Widget>[
            RewardSwiper(
              rewards: widget.rewards,
              header: Padding(
                padding: EdgeInsets.only(top: 50.0, bottom: 15.0),
                child: Text('REWARDS', style: Burnt.appBarTitleStyle.copyWith(color: Burnt.hintTextColor)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
              decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
            )
          ],
        ),
      ),
    );
  }
}

class _Props {
  final MyStore.Store store;
  final bool isLoggedIn;
  final List<Reward> rewards;

  _Props({this.store, this.isLoggedIn, this.rewards});

  static fromStore(Store<AppState> store, int storeId) {
    return _Props(
      store: store.state.store.stores[storeId],
      isLoggedIn: store.state.me.user != null,
      rewards: (store.state.store.rewards[storeId] ?? List<int>()).map((r) => store.state.reward.rewards[r]).toList(),
    );
  }
}
