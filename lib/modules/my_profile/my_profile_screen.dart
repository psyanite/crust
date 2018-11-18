import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/post/models/Post.dart';
import 'package:crust/modules/settings/settings_screen.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(store.state.auth.user.id)),
        converter: _ViewModel.fromStore,
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

  Widget _postList() {
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.all(16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate((List<Widget>.from(posts.map(_postCard)))),
      ),
    );
  }

  Widget _appBar(context) {
    return SliverToBoxAdapter(
        child: Container(
            child: Stack(children: <Widget>[
      Container(
        height: 200.0,
      ),
      Stack(children: <Widget>[
        Container(
            height: 80.0,
            decoration: new BoxDecoration(
              image: new DecorationImage(
                image: NetworkImage(user.picture),
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
                  image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(user.picture)))),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[Text(user.fullName), Text("@${user.username}")],
            ),
          )
        ]),
      ),
    ])));
  }

  Widget _postCard(Post post) {
    return Container(child: Column(children: <Widget>[_buildStoreDetails(post), _buildContent(post)]));
  }

  Widget _buildStoreDetails(Post post) {
    var details = <Widget>[
      Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(post.store.coverImage)))),
      Column(children: <Widget>[Text(post.store.name), Text(TimeUtil.format(post.postedAt))])
    ];
    if (post.type == PostType.review) details.add(Text(post.postReview.overallScore.toString()));
    var children = <Widget>[Row(children: details)];
    if (post.type == PostType.review) children.add(_buildStoreRatings(post));
    return Column(
      children: children,
    );
  }

  _buildStoreRatings(Post post) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
      _buildScore(post.postReview.tasteScore),
      Container(
        height: 30.0,
        width: 1.0,
        color: Colors.black38,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
      ),
      _buildScore(post.postReview.serviceScore),
      Container(
        height: 30.0,
        width: 1.0,
        color: Colors.black38,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
      ),
      _buildScore(post.postReview.valueScore),
      Container(
        height: 30.0,
        width: 1.0,
        color: Colors.black38,
        margin: const EdgeInsets.symmetric(horizontal: 5.0),
      ),
      _buildScore(post.postReview.ambienceScore),
    ]);
  }

  _buildScore(Score score, [double size = 50.0]) {
    var assetName;
    switch(score) {
      case(Score.bad): {
        assetName = 'assets/svgs/bread-bad.svg';
      }
      break;
      case(Score.bad): {
        assetName = 'assets/svgs/bread-okay.svg';
      }
      break;
      case(Score.bad): {
        assetName = 'assets/svgs/bread-good.svg';
      }
      break;
      default: {
        return new Container();
      }
    }
    return new SvgPicture.asset(
      assetName,
      width: size,
      height: size,
    );
  }

  _buildContent(Post post) {
    if (post.type == PostType.review) {
      return Text(post.postReview.body);
    }
    return Container(
      height: 350.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5.0),
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(post.postPhotos[0].photo))));
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

//class _MyPostList extends StatelessWidget {
//  final int userAccountId;
//
//  _MyPostList({Key key, this.userAccountId}) : super(key: key);
//
//  @override
//  Widget build(BuildContext context) {
//    return StoreConnector<AppState, dynamic>(
//        onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(userAccountId)),
//        converter: (Store<AppState> store) => store.state.auth.posts,
//        builder: (context, posts) => posts == null ? _loadingSliver() : ProfilePostList(posts: posts));
//  }
//}

class _ViewModel {
  final User user;
  final List<Post> posts;

  _ViewModel({this.user, this.posts});

  static fromStore(Store<AppState> store) {
    return _ViewModel(user: store.state.auth.user, posts: store.state.auth.posts);
  }
}
