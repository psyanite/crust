import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/common/carousel.dart';
import 'package:crust/components/post_list/carousel_wrapper.dart';
import 'package:crust/components/post_list/comment_screen.dart';
import 'package:crust/components/post_list/post_list.dart';
import 'package:crust/components/profile/profile_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
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
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  _showReview() {
    return post.type == PostType.review && post.postReview.body != null;
  }

  Widget _header() {
    if (post.isOfficialStorePost()) {
      return _officialHeaderContent();
    } else if (postListType == PostListType.forProfile) {
      return _profileHeaderContent();
    } else if (postListType == PostListType.forStore) {
      return _storeHeaderContent();
    } else {
      return _feedHeaderContent();
    }
  }

  Widget _officialHeaderContent() {
    var details = Row(
      children: <Widget>[
        _teaserImage(post.store.coverImage),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_name('${post.store.name} ⭐'), _postedAt()],
        ),
      ],
    );
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: post.store.id))),
        child: Padding(padding: EdgeInsets.only(bottom: 20.0), child: details),
      );
    });
  }

  Widget _profileHeaderContent() {
    var details = Row(
      children: <Widget>[
        _teaserImage(post.store.coverImage),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[_name(post.store.name), _postedAt()],
        ),
      ],
    );
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: post.store.id))),
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[details, _scoreIcon()],
          ),
        ),
      );
    });
  }

  Widget _storeHeaderContent() {
    var details = Row(
      children: <Widget>[
        _teaserImage(post.postedBy.profilePicture),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(children: <Widget>[
              _name(post.postedBy.displayName),
              Text(" @${post.postedBy.username}", style: TextStyle(color: Burnt.hintTextColor))
            ]),
            _postedAt(),
          ],
        ),
      ],
    );
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: post.postedBy.id))),
        child: Padding(
          padding: EdgeInsets.only(bottom: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[details, _scoreIcon()],
          ),
        ),
      );
    });
  }

  Widget _feedHeaderContent() {
    return Builder(builder: (context) {
      var details = InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: post.postedBy.id))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(children: <Widget>[
              _teaserImage(post.postedBy.profilePicture),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(children: <Widget>[
                    _name(post.postedBy.displayName),
                    Text(" @${post.postedBy.username}", style: TextStyle(color: Burnt.hintTextColor))
                  ]),
                  _postedAt(),
                ],
              ),
            ]),
            _scoreIcon()
          ],
        ),
      );
      var storeName = InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: post.store.id))),
        child: Padding(
          padding: EdgeInsets.only(top: 20.0, bottom: 3.0),
          child: Text(post.store.name, style: TextStyle(fontSize: 19.0, color: Burnt.lightTextColor)),
        ),
      );
      return Column(
        crossAxisAlignment: _showReview() ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: <Widget>[
          details,
          storeName,
        ],
      );
    });
  }

  Widget _name(text) {
    return Text(text, style: Burnt.titleStyle);
  }

  Widget _postedAt() {
    return Text(TimeUtil.format(post.postedAt), style: TextStyle(color: Burnt.hintTextColor));
  }

  Widget _scoreIcon() {
    if (post.type != PostType.review) return Container();
    return ScoreIcon(score: post.postReview.overallScore, size: 30.0);
  }

  Widget _teaserImage(image) {
    return Container(
      margin: EdgeInsets.only(right: 10.0),
      width: 50.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Burnt.imgPlaceholderColor,
        image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)),
      ),
    );
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
    var showCarousel = post.postPhotos.isNotEmpty;
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (_showReview()) _reviewBody(),
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
          Container(height: 5.0),
          Container(
            height: MediaQuery.of(context).size.width - 30.0,
            decoration: BoxDecoration(
              color: Burnt.imgPlaceholderColor,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(post.postPhotos[0].url),
              ),
            ),
          ),
          Container(height: 15.0),
          Row(mainAxisAlignment: MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.center, children: buttons),
          Container(height: 10.0),
        ],
      );
    });
  }
}
