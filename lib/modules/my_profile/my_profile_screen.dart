import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/my_profile/components/profile_post_list.dart';
import 'package:crust/modules/settings/settings_screen.dart';
import 'package:crust/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => store.state.auth.user, builder: (context, user) => _Presenter(user: user));
  }
}

class _Presenter extends StatelessWidget {
  final User user;

  _Presenter({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColors['white'],
        elevation: 0.0,
        actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          Container(
              width: 190.0,
              height: 190.0,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(user.picture)))),
          Text(user.fullName),
//          _MyPostList(userAccountId: user.id)
        ]),
      ),
    );
  }
}

class _MyPostList extends StatelessWidget {
  final int userAccountId;

  _MyPostList({Key key, this.userAccountId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(userAccountId)),
      converter: (Store<AppState> store) => store.state.auth.posts,
      builder: (context, posts) => ProfilePostList(posts: posts));
  }
}
