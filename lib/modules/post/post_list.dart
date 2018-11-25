import 'package:crust/models/Post.dart';
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
      minimum: const EdgeInsets.symmetric(horizontal: 16.0),
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
        delegate: SliverChildListDelegate(<Widget>[Text('No posts')]),
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
        ? Text(post.store.name, style: TextStyle(fontWeight: Burnt.fontBold, fontSize: 20.0))
        : Row(children: <Widget>[
            Text(post.postedBy.displayName, style: TextStyle(fontWeight: Burnt.fontBold, fontSize: 20.0)),
            Text(" @${post.postedBy.username}")
          ]);
    var details = Row(children: <Widget>[
      Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0), image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)))),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[name, Text(TimeUtil.format(post.postedAt))]),
      )
    ]);
    if (post.type == PostType.review) {
      details = Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[details]);
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
        ScoreIcon(score: post.postReview.tasteScore, name: 'Taste'),
        ScoreIcon(score: post.postReview.serviceScore, name: 'Service'),
        ScoreIcon(score: post.postReview.valueScore, name: 'Value'),
        ScoreIcon(score: post.postReview.ambienceScore, name: 'Ambience'),
      ]),
    );
  }

  Widget _content(Post post) {
    if (post.type == PostType.review) {
      return Container(
          padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
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
}

enum PostListType { forStore, forProfile }
