import 'dart:async';

import 'package:crust/components/my_profile/set_picture_screen.dart';
import 'package:crust/components/my_profile/update_profile_screen.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/screens/about_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) => store.dispatch(FetchMyPosts(store.state.me.user.id)),
      converter: _Props.fromStore,
      builder: (context, props) {
        return _Presenter(user: props.user, refreshPage: props.refreshPage, logout: props.logout);
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final User user;
  final Function refreshPage;
  final Function logout;
  final String defaultProfilePic = 'https://firebasestorage.googleapis.com/v0/b/burntoast-fix.appspot.com/o/users%2Fprofile-pictures%2F1565423370052-9201.jpg?alt=media&token=1a80c164-4ca6-4174-bd46-c8c265c17ae9';

  _Presenter({Key key, this.user, this.refreshPage, this.logout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      endDrawer: _drawer(context),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: CustomScrollView(slivers: <Widget>[
          _appBar(),
          PostList(
            noPostsView: Text('Start reviewing now and your reviews will show up here!'),
            posts: user.posts,
            postListType: PostListType.forProfile,
          )
        ]),
      ),
    );
  }

  Future<void> _refresh() async {
    await refreshPage();
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
      child: Column(children: <Widget>[
        Container(
          child: Stack(children: <Widget>[
            Container(height: 250.0),
            Stack(children: <Widget>[
              _profilePicture(),
              _menuButton(),
            ]),
            Positioned(
              left: 50.0,
              top: 100.0,
              child: Row(children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Burnt.separator,
                    borderRadius: BorderRadius.circular(150.0),
                    border: Border.all(
                      color: Colors.white,
                      width: 4.0,
                    ),
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(user.profilePicture),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.0, top: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(user.displayName, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
                      Text("@${user.username}"),
                    ],
                  ),
                )
              ]),
            ),
          ]),
        ),
        if (user.tagline != null) Padding(padding: EdgeInsets.only(top: 13.0, right: 16.0, left: 16.0), child: Text(user.tagline)),
        if (user.profilePicture == defaultProfilePic) _setProfilePictureButton()
      ]),
    );
  }

  Widget _setProfilePictureButton() {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: SmallButton(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SetPictureScreen())),
          padding: EdgeInsets.only(left: 7.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, size: 16.0, color: Colors.white),
              Container(width: 2.0),
              Text('Set Profile Picture', style: TextStyle(fontSize: 16.0, color: Colors.white))
            ],
          ),
        ),
      );
    });
  }

  Widget _profilePicture() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(user.profilePicture),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _menuButton() {
    return Container(
      height: 150.0,
      decoration: BoxDecoration(color: Color(0x55000000)),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Builder(builder: (context) {
              return IconButton(
                icon: Icon(CupertinoIcons.ellipsis),
                color: Colors.white,
                iconSize: 40.0,
                onPressed: () => Scaffold.of(context).openEndDrawer(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _drawer(BuildContext context) {
    return Drawer(
      child: Center(
        child: ListView(padding: EdgeInsets.zero, children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SetPictureScreen())),
            child: Container(
              width: 300.0,
              height: 300.0,
              decoration: BoxDecoration(
                color: Burnt.separator,
                borderRadius: BorderRadius.circular(150.0),
                border: Border.all(
                  color: Colors.white,
                  width: 4.0,
                ),
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(user.profilePicture),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 12.0, bottom: 20.0),
            child: Column(
              children: <Widget>[
                Text(user.displayName, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
                Text("@${user.username}")
              ],
            ),
          ),
          ListTile(
            title: Text('Update Profile', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => UpdateProfileScreen()));
            },
          ),
          ListTile(
            title: Text('About', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(context, MaterialPageRoute(builder: (_) => AboutScreen()));
            },
          ),
          ListTile(
            title: Text('Log out', style: TextStyle(fontSize: 18.0)),
            onTap: () {
              logout();
              Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
            },
          ),
        ]),
      ),
    );
  }
}

class _Props {
  final User user;
  final Function refreshPage;
  final Function logout;

  _Props({this.user, this.refreshPage, this.logout});

  static fromStore(Store<AppState> store) {
    return _Props(
      user: store.state.me.user,
      refreshPage: () => store.dispatch(FetchMyPosts(store.state.me.user.id)),
      logout: () => store.dispatch(Logout()),
    );
  }
}
