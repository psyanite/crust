import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/screens/settings_screen.dart';
import 'package:crust/models/user.dart';
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
        onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(store.state.me.user.id)),
        converter: _Props.fromStore,
        builder: (context, props) => _Presenter(user: props.user));
  }
}

class _Presenter extends StatelessWidget {
  final User user;

  _Presenter({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[
      _appBar(),
      PostList(
          noPostsView: Text('Your posts are displayed here, start posting now!'), posts: user.posts, postListType: PostListType.forProfile)
    ]);
  }

  Widget _appBar() {
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
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Builder(
                      builder: (context) => IconButton(
                            icon: Icon(CupertinoIcons.ellipsis),
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
                  color: Burnt.separator,
                  borderRadius: BorderRadius.circular(150.0),
                  border: new Border.all(
                    color: Colors.white,
                    width: 4.0,
                  ),
                  image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(user.profilePicture)))),
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(user.displayName, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
                Text("@${user.username}")
              ],
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

  static fromStore(Store<AppState> store) {
    return _Props(user: store.state.me.user);
  }
}
