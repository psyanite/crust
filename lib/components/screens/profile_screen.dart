import 'dart:async';

import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/screens/loading_screen.dart';
import 'package:crust/components/screens/settings_screen.dart';
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
          if (store.state.user.users == null || store.state.user.users[userId] == null)
            return store.dispatch(FetchUserByUserIdRequest(userId));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store, userId),
        builder: (context, props) => _Presenter(user: props.user, refreshPage: props.refreshPage));
  }
}

class _Presenter extends StatefulWidget {
  final User user;
  final Function refreshPage;

  _Presenter({Key key, this.user, this.refreshPage}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  @override
  Widget build(BuildContext context) {
    var user = widget.user;
    if (user == null) {
      return LoadingScreen();
    }
    var body = CustomScrollView(slivers: <Widget>[
      _appBar(),
      PostList(
          noPostsView: Text('Looks like ${user.firstName} hasn\'t posted anything yet.'),
          posts: user.posts,
          postListType: PostListType.forProfile)
    ]);
    return Scaffold(body: RefreshIndicator(onRefresh: _refresh, child: body));
  }

  Future<void> _refresh() async {
    await widget.refreshPage();
  }

  Widget _appBar() {
    var user = widget.user;
    return SliverToBoxAdapter(
        child: Container(
            child: Stack(children: <Widget>[
      Container(
        height: 200.0,
      ),
      Stack(children: <Widget>[
        Container(
            height: 100.0,
            decoration: BoxDecoration(
              color: Burnt.separator,
              image: DecorationImage(
                image: NetworkImage(user.profilePicture),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            height: 100.0,
            decoration: BoxDecoration(color: Color(0x55000000)),
            child: SafeArea(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  BackArrow(color: Colors.white),
                  Builder(
                      builder: (context) => IconButton(
                            icon: const Icon(CupertinoIcons.ellipsis),
                            color: Colors.white,
                            iconSize: 40.0,
                            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                          )),
                ],
              ),
            )),
      ]),
      Positioned(
        left: 50.0,
        top: 50.0,
        child: Row(children: <Widget>[
          Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
                  color: Burnt.imgPlaceholderColor,
                  borderRadius: BorderRadius.circular(150.0),
                  border: Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(user.profilePicture)))),
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(user.displayName, style: Burnt.titleStyle), Text("@${user.username}")],
            ),
          )
        ]),
      ),
    ])));
  }
}

class _Props {
  final User user;
  final Function refreshPage;

  _Props({this.user, this.refreshPage});

  static fromStore(Store<AppState> store, int userId) {
    if (store.state.user.users == null) {
      return _Props(user: null, refreshPage: null);
    }

    return _Props(user: store.state.user.users[userId], refreshPage: () => store.dispatch(FetchUserByUserIdRequest(userId)));
  }
}
