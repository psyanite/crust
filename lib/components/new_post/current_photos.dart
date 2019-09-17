import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/photo/photo_overlay.dart';
import 'package:crust/models/post.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CurrentPhotos extends StatefulWidget {
  final List<PostPhoto> photos;
  final Function onPhotoDelete;

  CurrentPhotos({Key key, this.photos, this.onPhotoDelete}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(images: photos, onPhotoDelete: onPhotoDelete);
}

class _PresenterState extends State<CurrentPhotos> {
  final List<PostPhoto> images;
  final Function onPhotoDelete;

  _PresenterState({this.images, this.onPhotoDelete});

  @override
  Widget build(BuildContext context) {
    var size = (MediaQuery.of(context).size.width - 20.0 - 5 * 2.0) / 5;
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      sliver: SliverToBoxAdapter(
        child: Container(
          height: images.length < 6 ? size + 3.0 : size * 2 + 6.0,
          child: Column(
            children: <Widget>[
              images.length < 6 ? _row(images.sublist(0), size) : _row(images.sublist(0, 5), size),
              if (images.length > 5) _row(images.sublist(5, images.length), size)
            ],
          ),
        ),
      ),
    );
  }

  Widget _row(List<PostPhoto> images, double size) {
    var children = List<Widget>.from(
      images.map((i) {
        return InkWell(
          child: Container(
              color: Burnt.imgPlaceholderColor,
              padding: EdgeInsets.symmetric(horizontal: 1.0),
              width: size,
              height: size,
              child: CachedNetworkImage(
                imageUrl: i.url,
                fit: BoxFit.cover,
                fadeInDuration: Duration(milliseconds: 100),
              )),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoOverlay(photo: i, onPhotoDelete: onPhotoDelete))),
        );
      }),
    );
    return Padding(
      padding: EdgeInsets.only(bottom: 3.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: children,
      ),
    );
  }
}
