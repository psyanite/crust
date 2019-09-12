import 'dart:async';

import 'package:crust/components/my_profile/my_profile_screen.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/profile/follow_user_button.dart';
import 'package:crust/components/screens/loading_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
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
        if (store.state.user.users == null || store.state.user.users[userId] == null) {
          return store.dispatch(FetchUserByUserId(userId));
        }
      },
      converter: (Store<AppState> store) => _Props.fromStore(store, userId),
      builder: (context, props) => _Presenter(user: props.me, myProfile: props.myProfile),
    );
  }
}

class _Presenter extends StatefulWidget {
  final User user;
  final bool myProfile;

  _Presenter({Key key, this.user, this.myProfile}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie;
  List<Post> posts;
  bool loading = false;
  int limit = 12;
  int offset = 0;

  @override
  initState() {
    super.initState();
    if (widget.myProfile == true) _redirect();
    _scrollie = ScrollController()
      ..addListener(() {
        if (loading == false && limit > 0 && _scrollie.position.extentAfter < 500) _getMorePosts();
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
    this.setState(() => posts = fresh);
  }

  removeFromList(int index) {
    this.setState(() => posts = List<Post>.from(posts)..removeAt(index));
  }

  Future<List<Post>> _getPosts() async {
    return PostService.fetchPostsByUserId(userId: widget.user.id, limit: limit, offset: offset);
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
    var update = List<Post>.from(posts)..addAll(fresh);
    this.setState(() {
      offset = offset + limit;
      posts = update;
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    if (user == null) return LoadingScreen();
    return Scaffold(
      body: CustomScrollView(slivers: <Widget>[
        _appBar(),
        PostList(
          noPostsView: Text('Looks like ${user.firstName} hasn\'t written any reviews yet.'),
          postListType: PostListType.forProfile,
          posts: posts,
          removeFromList: removeFromList,
        ),
        if (loading == true) LoadingSliver(),
      ]),
    );
  }

  Widget _appBar() {
    var user = widget.user;
    return SliverToBoxAdapter(
      child: Column(children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(height: 200.0),
              Stack(children: <Widget>[
                Container(
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Burnt.separator,
                    image: DecorationImage(image: NetworkImage(user.profilePicture), fit: BoxFit.cover),
                  ),
                ),
                Container(
                  height: 150.0,
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
                margin: EdgeInsets.only(top: 70.0),
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
                Text("@${user.username}"),
              ]),
              Container(height: 10.0),
              _followButton(),
            ],
          ),
        ),
        if (user.tagline != null) _tagline(),
        Container(
          margin: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0),
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
        followedView: SolidButton(
          padding: EdgeInsets.symmetric(vertical: 6.0, horizontal: 10.0),
          color: Color(0x10604B41),
          children: <Widget>[Text('Following', style: TextStyle(fontSize: 18.0, color: Burnt.lightTextColor))],
        ),
      );
    });
  }

  Widget _profilePicture(String picture) {
    return Container(
      width: 150.0,
      height: 150.0,
      decoration: BoxDecoration(
        color: Burnt.separator,
        borderRadius: BorderRadius.circular(150.0),
        border: Border.all(color: Colors.white, width: 4.0),
        image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(picture)),
      ),
    );
  }
}

class _Props {
  final User me;
  final bool myProfile;

  _Props({this.me, this.myProfile = false});

  static fromStore(Store<AppState> store, int userId) {
    var me = store.state.me.user;
    var myProfile = me != null && me?.id == userId;
    if (store.state.user.users == null || myProfile) {
      return _Props(me: null, myProfile: myProfile);
    }
    return _Props(me: store.state.user.users[userId]);
  }
}
