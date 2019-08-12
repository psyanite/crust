import 'dart:async';

import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/screens/loading_screen.dart';
import 'package:crust/components/screens/oops_screen.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/user/user_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
      builder: (context, props) => _Presenter(user: props.user, refreshPage: props.refreshPage, error: props.error),
    );
  }
}

class _Presenter extends StatefulWidget {
  final User user;
  final Function refreshPage;
  final bool error;

  _Presenter({Key key, this.user, this.refreshPage, this.error}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    if (widget.error == true) return OopsScreen();
    var user = widget.user;
    if (user == null) return LoadingScreen();
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(slivers: <Widget>[
          _appBar(),
          PostList(
            noPostsView: Text('Looks like ${user.firstName} hasn\'t written any reviews yet.'),
            posts: user.posts,
            postListType: PostListType.forProfile,
          ),
        ]),
      ),
    );
  }

  Future<void> _refresh() async {
    await widget.refreshPage();
  }

  Widget _appBar() {
    var user = widget.user;
    return SliverToBoxAdapter(
      child: Column(children: <Widget>[
        Container(
          child: Stack(
            children: <Widget>[
              Container(height: 250.0),
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
              Positioned(
                left: 50.0,
                top: 100.0,
                child: Row(
                  children: <Widget>[
                    _profilePicture(user.profilePicture),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[Text(user.displayName, style: Burnt.titleStyle), Text("@${user.username}")],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        if (user.tagline != null) Padding(padding: EdgeInsets.only(top: 13.0, right: 16.0, left: 16.0), child: Text(user.tagline)),
      ]),
    );
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
  final User user;
  final Function refreshPage;
  final bool error;

  _Props({this.user, this.refreshPage, this.error = false});

  static fromStore(Store<AppState> store, int userId) {
    if (store.state.user.users == null || store.state.me.user?.id == userId) {
      return _Props(user: null, refreshPage: () {}, error: true);
    }
    return _Props(user: store.state.user.users[userId], refreshPage: () => store.dispatch(FetchUserByUserId(userId)));
  }
}
