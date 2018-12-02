import 'package:crust/components/carousel.dart';
import 'package:crust/models/post.dart';
import 'package:crust/components/screens/profile_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  final List<Post> posts;
  final PostListType postListType;

  PostList({Key key, this.posts, this.postListType});

  @override
  Widget build(BuildContext context) {
    if (posts == null) return LoadingSliver();
    if (posts.length == 0) return _noPostsNotice();
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(horizontal: 15.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate((List<Widget>.from(posts.map(_postCard)))),
      ),
    );
  }

  Widget _noPostsNotice() {
    return SliverSafeArea(
      top: false,
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          Column(
          children: <Widget>[
            Text('We don\'t have any posts yet'),
//            RaisedButton(child: Text('Add One Now'), onPressed: () {},)
          ]
        )]),
      ),
    );
  }

  Widget _postCard(Post post) {
    return Container(
        decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
        child: Column(children: <Widget>[_header(post), _content(post)]));
  }

  Widget _header(Post post) {
    var image = postListType == PostListType.forProfile ? post.store.coverImage : post.postedBy.profilePicture;
    var name = postListType == PostListType.forProfile
        ? Text(post.store.name, style: Burnt.title)
        : Row(children: <Widget>[
            Text(post.postedBy.displayName, style: Burnt.title),
            Text(" @${post.postedBy.username}")
          ]);
    var details = Row(children: <Widget>[
      Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[name, Text(TimeUtil.format(post.postedAt))]),
      )
    ]);
    if (post.type == PostType.review) {
      details = Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[details, ScoreIcon(score: post.postReview.overallScore, size: 30.0)]);
    }
    var children = <Widget>[Container(padding: EdgeInsets.only(top: 15.0, bottom: 10.0), child: details)];
    var nextScreen =
        postListType == PostListType.forProfile ? StoreScreen(storeId: post.store.id) : ProfileScreen(userId: post.postedBy.id);
    return Builder(
      builder: (context) => InkWell(
            onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => nextScreen),
                ),
            child: Column(
              children: children,
            ),
          ),
    );
  }

  Widget _content(Post post) {
    if (post.type == PostType.review) {
      var children = <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 10.0),
          child: Text(post.postReview.body),
        ),
      ];
      if (post.postPhotos != null && post.postPhotos.length != 0) {
        children.add(Carousel(images: post.postPhotos));
      }
      return Container(padding: EdgeInsets.only(top: 10.0, bottom: 20.0), child: Column(children: children));
    }
    return Builder(
      builder: (context) => Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: Container(
            height: MediaQuery.of(context).size.width - 30.0,
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Burnt.separator)),
                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(post.postPhotos[0])))),
      ),
    );
  }
}

enum PostListType { forStore, forProfile }
