import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/carousel.dart';
import 'package:crust/components/screens/profile_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostList extends StatelessWidget {
  final Widget noPostsView;
  final List<Post> posts;
  final PostListType postListType;

  PostList({Key key, this.noPostsView, this.posts, this.postListType});

  @override
  Widget build(BuildContext context) {
    if (posts == null) return LoadingSliver();
    if (posts.length == 0) return _noPostsNotice();
    return SliverSafeArea(
        minimum: EdgeInsets.symmetric(horizontal: 15.0),
        sliver: SliverList(delegate: SliverChildBuilderDelegate((builder, i) => _postCard(posts[i]), childCount: posts.length)));
  }

  Widget _noPostsNotice() {
    return SliverSafeArea(
      minimum: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildListDelegate(<Widget>[
          Column(children: <Widget>[
            noPostsView
//            RaisedButton(child: Text('Add One Now'), onPressed: () {},)
          ])
        ]),
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
        ? Text(post.store.name, style: Burnt.titleStyle)
        : Row(children: <Widget>[Text(post.postedBy.displayName, style: Burnt.titleStyle), Text(" @${post.postedBy.username}")]);
    var details = Row(children: <Widget>[
      Container(
          width: 50.0,
          height: 50.0,
          decoration:
              BoxDecoration(color: Burnt.imgPlaceholderColor, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)))),
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
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen)),
            child: Column(
              children: children,
            ),
          ),
    );
  }

  Widget _content(Post post) {
    var children = <Widget>[];
    if (post.type == PostType.review && post.postReview.body != null) {
      children.add(Padding(
        padding: EdgeInsets.only(bottom: 10.0),
        child: Text(post.postReview.body),
      ));
    }
    if (post.postPhotos.length == 1) {
      children.add(_imagePreview(post.postPhotos[0]));
    }
    if (post.postPhotos.length > 1) {
      children.add(_carousel(post.postPhotos));
    }
    return Container(padding: EdgeInsets.only(top: 10.0, bottom: 20.0), child: Column(children: children));
  }

  Widget _imagePreview(String photo) {
    return Builder(
        builder: (context) => Container(
            height: MediaQuery.of(context).size.width - 30.0,
            decoration: BoxDecoration(
                color: Burnt.imgPlaceholderColor,
                border: Border(bottom: BorderSide(color: Burnt.separator)),
                image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(photo)))));
  }

  Widget _carousel(List<String> photos) {
    final List<Widget> widgets = photos
        .map<Widget>((image) => CachedNetworkImage(
              imageUrl: image,
              fit: BoxFit.cover,
              fadeInDuration: Duration(milliseconds: 100),
            ))
        .toList(growable: false);
    return Carousel(images: widgets);
  }
}

enum PostListType { forStore, forProfile }
