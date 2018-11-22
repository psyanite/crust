import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:crust/models/user.dart';
import 'package:crust/models/Post.dart';
import 'package:crust/modules/screens/settings_screen.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(store.state.me.me.id)),
        converter: _Props.fromStore,
        builder: (context, vm) => _Presenter(user: vm.user, posts: vm.posts));
  }
}

class _Presenter extends StatelessWidget {
  final User user;
  final List<Post> posts;

  _Presenter({Key key, this.user, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[_appBar(context), posts == null ? _loadingSliver() : _postList()]);
  }

  Widget _appBar(context) {
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
                IconButton(
                  icon: const Icon(CupertinoIcons.ellipsis),
                  color: Colors.white,
                  iconSize: 40.0,
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
                ),
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

  Widget _postList() {
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate((List<Widget>.from(posts.map(_postCard)))),
      ),
    );
  }

  Widget _postCard(Post post) {
    return Container(
      decoration: BoxDecoration(border: Border(
        bottom: BorderSide(color: Burnt.separator)
      )),
      child: Column(children: <Widget>[_storeDetails(post), _content(post)])
    );
  }

  Widget _storeDetails(Post post) {
    var details = Row(
      children: <Widget>[
        Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5.0),
            image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(post.store.coverImage)))),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(post.store.name, style: TextStyle(fontWeight: Burnt.fontBold, fontSize: 20.0)),
              Text(TimeUtil.format(post.postedAt))
            ]
          ),
        )
      ]
    );
    if (post.type == PostType.review) {
      details = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          details
        ]
      );
    }
    var children = <Widget>[Container(padding: EdgeInsets.only(top: 15.0, bottom: 10.0), child: details)];
    if (post.type == PostType.review) {
      children.add(_storeRatings(post));
    }
    return Column(
      children: children,
    );
  }

  Widget _storeRatings(Post post) {
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator), bottom: BorderSide(color: Burnt.separator))),
      padding: EdgeInsets.only(top: 10.0, bottom: 5.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        _score(post.postReview.tasteScore, name: 'Taste'),
        _score(post.postReview.serviceScore, name: 'Service'),
        _score(post.postReview.valueScore, name: 'Value'),
        _score(post.postReview.ambienceScore, name: 'Ambience'),
      ]),
    );
  }

  Widget _score(Score score, {double size = 25.0, String name = ''}) {
    var assetName;
    switch (score) {
      case (Score.bad):
        {
          assetName = 'assets/svgs/bread-bad.svg';
        }
        break;
      case (Score.okay):
        {
          assetName = 'assets/svgs/bread-okay.svg';
        }
        break;
      case (Score.good):
        {
          assetName = 'assets/svgs/bread-good.svg';
        }
        break;
      default:
        {
          return new Container();
        }
    }
    var children = <Widget>[
      SvgPicture.asset(
        assetName,
        width: size,
        height: size,
      )
    ];
    if (name != '') {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(name),
      ));
    }
    return Column(
      children: children
    );
  }

  Widget _content(Post post) {
    if (post.type == PostType.review) {
      return Container(padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
        child: Column(children: <Widget>[
          Text(post.postReview.body),
        ]));
    }
    return Padding(
      padding: EdgeInsets.only(bottom: 20.0),
      child: Container(
          height: 350.0,
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Burnt.separator)),
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(post.postPhotos[0].photo)))),
    );
  }

  Widget _loadingSliver() {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class _Props {
  final User user;
  final List<Post> posts;

  _Props({this.user, this.posts});

  static fromStore(Store<AppState> store) {
    return _Props(user: store.state.me.me, posts: store.state.me.posts);
  }
}
