import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/my_profile/my_profile_screen.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/profile/follow_user_button.dart';
import 'package:crust/components/screens/loading_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:crust/state/user/user_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ProfileScreen extends StatelessWidget {
  final int userId;

  ProfileScreen({Key key, this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) {
        if (store.state.user.users[userId] == null) {
          return store.dispatch(FetchUserByUserId(userId));
        }
      },
      converter: (Store<AppState> store) => _Props.fromStore(store, userId),
      builder: (context, props) => _Presenter(userId: userId, user: props.user, myProfile: props.myProfile),
    );
  }
}

class _Presenter extends StatefulWidget {
  final int userId;
  final User user;
  final bool myProfile;

  _Presenter({Key key, this.userId, this.user, this.myProfile}) : super(key: key);

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
    if (widget.myProfile == true) _redirect();
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

  _redirect() async {
    return Timer(Duration(microseconds: 1), () {
      Navigator.pop(context);
      Navigator.push(context, MaterialPageRoute(builder: (_) => MyProfileScreen()));
    });
  }

  _load() async {
    var fresh = await _getPosts();
    this.setState(() => _posts = fresh);
  }

  Future<void> _refresh() async {
    var fresh = await PostService.fetchPostsByUserId(userId: widget.userId, limit: 12, offset: 0);
    this.setState(() {
      _limit = 12;
      _posts = fresh;
    });
  }

  _removeFromList(index, postId) {
    this.setState(() => _posts = List<Post>.from(_posts)..removeAt(index));
  }

  Future<List<Post>> _getPosts() async {
    var offset = _posts != null ? _posts.length : 0;
    return PostService.fetchPostsByUserId(userId: widget.userId, limit: _limit, offset: offset);
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

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    if (user == null) return LoadingScreen();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        displacement: 30.0,
        child: CustomScrollView(slivers: <Widget>[
          _appBar(),
          PostList(
            noPostsView: Text('Looks like ${user.firstName} hasn\'t written any reviews yet.'),
            postListType: PostListType.forProfile,
            posts: _posts,
            removeFromList: _removeFromList,
          ),
          if (_loading == true) LoadingSliver(),
        ]),
      ),
    );
  }

  Widget _appBar() {
    var user = widget.user;
    return SliverToBoxAdapter(
      child: Column(children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(height: 360.0),
              Stack(children: <Widget>[
                NetworkImg(user.profilePicture, height: 290.0),
                Container(
                  height: 290.0,
                  decoration: BoxDecoration(color: Color(0x55000000)),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Container(height: 55.0, child: BackArrow(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(top: 100.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[_profilePicture(user.profilePicture)],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(user.displayName, style: Burnt.titleStyle),
                Container(width: 4.0),
                Text('@${user.username}'),
              ]),
              Container(height: 15.0),
              _followButton(),
            ],
          ),
        ),
        if (user.tagline != null) _tagline(),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 25.0),
          decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
        )
      ]),
    );
  }

  Widget _tagline() {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 15.0),
      child: Text(widget.user.tagline),
    );
  }

  Widget _followButton() {
    return Builder(builder: (context) {
      return FollowUserButton(
        userId: widget.user.id,
        displayName: widget.user.displayName,
        followView: Container(width: 80.0, child: BurntButton(padding: 6.0, text: 'Follow', fontSize: 18.0)),
        followedView: SmallButton(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          color: Color(0x10604B41),
          child: Text('Following', style: TextStyle(fontSize: 18.0, color: Burnt.lightTextColor)),
        ),
      );
    });
  }

  Widget _profilePicture(String picture) {
    return Container(
      width: 250.0,
      height: 250.0,
      decoration: BoxDecoration(
        color: Burnt.separator,
        borderRadius: BorderRadius.circular(150.0),
        border: Border.all(color: Colors.white, width: 4.0),
        image: DecorationImage(fit: BoxFit.fill, image: CachedNetworkImageProvider(picture)),
      ),
    );
  }
}

class _Props {
  final User user;
  final bool myProfile;

  _Props({this.user, this.myProfile = false});

  static fromStore(Store<AppState> store, int userId) {
    var me = store.state.me.user;
    var myProfile = me != null && me?.id == userId;
    if (myProfile) {
      return _Props(user: null, myProfile: myProfile);
    }
    return _Props(user: store.state.user.users[userId]);
  }
}
