import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/carousel.dart';
import 'package:crust/components/post_list/carousel_wrapper.dart';
import 'package:crust/components/post_list/comment_screen.dart';
import 'package:crust/components/post_list/post_list_list.dart';
import 'package:crust/components/profile/profile_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PostInfo extends StatelessWidget {
  final Post post;
  final PostListType postListType;
  final List<Widget> buttons;

  PostInfo({Key key, this.post, this.postListType, this.buttons}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      _header(),
      _content(),
    ];
    return Container(
      padding: EdgeInsets.only(top: 30.0, bottom: 10.0),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Burnt.separator))),
      child: Column(children: children),
    );
  }

  Widget _name() {
    if (postListType == PostListType.forProfile) {
      return Text(post.store.name, style: Burnt.titleStyle);
    } else {
      if (post.postedBy == null) {
        return Text('${post.store.name} ⭐', style: Burnt.titleStyle);
      } else {
        return Row(children: <Widget>[
          Text(post.postedBy.displayName, style: Burnt.titleStyle),
          Text(" @${post.postedBy.username}", style: TextStyle(color: Burnt.hintTextColor))
        ]);
      }
    }
  }

  Widget _header() {
    var image = postListType == PostListType.forProfile || post.postedBy == null ? post.store.coverImage : post.postedBy.profilePicture;
    var details = Row(
      children: <Widget>[
        if (post.postedBy != null)
          Container(
            width: 50.0,
            height: 50.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)),
            ),
          ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: post.postedBy != null ? 10.0 : 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[_name(), Text(TimeUtil.format(post.postedAt), style: TextStyle(color: Burnt.hintTextColor))],
          ),
        ),
      ],
    );
    if (post.type == PostType.review && post.postedBy != null) {
      details = Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[details, ScoreIcon(score: post.postReview.overallScore, size: 30.0)],
      );
    }
    var nextScreen = postListType == PostListType.forProfile || post.postedBy == null
        ? StoreScreen(storeId: post.store.id)
        : ProfileScreen(userId: post.postedBy.id);
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => nextScreen)),
        child: Column(
          children: <Widget>[Container(padding: EdgeInsets.only(bottom: 20.0), child: details)],
        ),
      );
    });
  }

  Widget _reviewBody() {
    return Builder(builder: (context) {
      return InkWell(
        child: Padding(padding: EdgeInsets.only(bottom: 20.0), child: Text(post.postReview.body)),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(post: post))),
      );
    });
  }

  Widget _content() {
    var showReview = post.type == PostType.review && post.postReview.body != null;
    var showCarousel = post.postPhotos.isNotEmpty;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (showReview) _reviewBody(),
          if (showCarousel) _carousel(),
          if (!showCarousel) _textPostFooter(),
        ],
      ),
    );
  }

  Widget _textPostFooter() {
    return Padding(
      padding: EdgeInsets.only(bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: buttons,
      ),
    );
  }

  Widget _carousel() {
    if (post.postPhotos.length == 1) {
      return _singlePhoto();
    }
    final List<Widget> widgets = post.postPhotos.map<Widget>((photo) {
      return CachedNetworkImage(
        imageUrl: photo.url,
        fit: BoxFit.cover,
        fadeInDuration: Duration(milliseconds: 100),
      );
    }).toList();

    return CarouselWrapper(
      postId: post.id,
      child: Carousel(
        images: widgets,
        left: Row(
          children: buttons,
        ),
      ),
    );
  }

  Widget _singlePhoto() {
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
            height: MediaQuery.of(context).size.width - 30.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(post.postPhotos[0].url),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 6.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: buttons,
            ),
          )
        ],
      );
    });
  }
}
