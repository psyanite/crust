import 'package:crust/components/post_list.dart';
import 'package:crust/components/screens/loading_screen.dart';
import 'package:crust/components/screens/settings_screen.dart';
import 'package:crust/models/user.dart';
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
        builder: (context, props) => _Presenter(user: props.user));
  }
}

class _Presenter extends StatelessWidget {
  final User user;

  _Presenter({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return LoadingScreen();
    }
    return Scaffold(
        body: CustomScrollView(slivers: <Widget>[_appBar(), PostList(posts: user.posts, postListType: PostListType.forProfile)]));
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
        child: Container(
            child: Stack(children: <Widget>[
      Container(
        height: 180.0,
      ),
      Stack(children: <Widget>[
        Container(
            height: 80.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: NetworkImage(user.profilePicture),
                fit: BoxFit.cover,
              ),
            )),
        Container(
            height: 80.0,
            decoration: new BoxDecoration(color: Color(0x55000000)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Builder(
                    builder: (context) => IconButton(
                          icon: const Icon(CupertinoIcons.ellipsis),
                          color: Colors.white,
                          iconSize: 40.0,
                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                        )),
              ],
            )),
      ]),
      Positioned(
        left: 50.0,
        top: 30.0,
        child: Row(children: <Widget>[
          Container(
              width: 150.0,
              height: 150.0,
              decoration: BoxDecoration(
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
              children: <Widget>[Text(user.displayName, style: Burnt.title), Text("@${user.username}")],
            ),
          )
        ]),
      ),
    ])));
  }
}

class _Props {
  final User user;

  _Props({this.user});

  static fromStore(Store<AppState> store, int userId) {
    return _Props(user: store.state.user.users == null ? null : store.state.user.users[userId]);
  }
}
