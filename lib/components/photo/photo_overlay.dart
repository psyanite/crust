import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/models/post.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhotoOverlay extends StatefulWidget {
  final PostPhoto photo;
  final Function onPhotoDelete;

  PhotoOverlay({Key key, this.photo, this.onPhotoDelete}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(photo: photo, onPhotoDelete: onPhotoDelete);
}

class _PresenterState extends State<PhotoOverlay> {
  final PostPhoto photo;
  final Function onPhotoDelete;
  bool showDeleteConfirm;

  _PresenterState({this.photo, this.onPhotoDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Burnt.paper,
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _closeButton(context),
            _photo(context),
            Container(),
          ],
        ),
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: IconButton(icon: Icon(Icons.clear, size: 30.0), color: Burnt.textBodyColor, onPressed: () => Navigator.pop(context)),
        )
      ],
    );
  }

  Widget _photo(BuildContext context) {
    var size = MediaQuery.of(context).size.width - 30.0;
    return Column(
      children: <Widget>[
        Container(
          height: size,
          width: size,
          child: CachedNetworkImage(
            imageUrl: photo.url,
            fit: BoxFit.cover,
            fadeInDuration: Duration(milliseconds: 100),
          ),
        ),
        Container(height: 10.0),
        _deleteButton(context),
      ],
    );
  }

  Widget _deleteButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 30.0),
          child: SmallButton(
            onTap: () {
              onPhotoDelete(photo);
              Navigator.pop(context);
            },
            padding: EdgeInsets.only(left: 7.0, right: 12.0, top: 10.0, bottom: 10.0),
            child: Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Icon(
                Icons.delete_outline,
                size: 16.0,
                color: Colors.white,
              ),
              Container(width: 2.0),
              Text('Remove Photo', style: TextStyle(fontSize: 16.0, color: Colors.white))
            ]),
          ),
        )
      ],
    );
  }
}
