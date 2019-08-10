import 'dart:typed_data';

import 'package:crust/components/carousel.dart';
import 'package:crust/components/new_post/carousel_page.dart';
import 'package:crust/components/new_post/image_preview.dart';
import 'package:crust/presentation/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PhotoSelector extends StatelessWidget {
  final List<Uint8List> images;
  final Function(List<Asset>) onSelectImages;
  final String addText;
  final String changeText;
  final int max;

  PhotoSelector({Key key, this.images, this.onSelectImages, this.addText = 'Add Photos', this.changeText = 'Change Photos', this.max = 10}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var buttonText = images.isNotEmpty ? changeText : addText;
    return Column(
      children: <Widget>[
        if (images.length == 1) ImagePreview(images[0]),
        if (images.length > 1) _carousel(),
        SmallButton(
          onPressed: () => _loadAssets(context),
          padding: EdgeInsets.only(left: 7.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add, size: 16.0, color: Colors.white),
              Container(width: 2.0),
              Text(buttonText, style: TextStyle(fontSize: 16.0, color: Colors.white))
            ],
          ),
        ),
      ],
    );
  }

  Widget _carousel() {
    final List<Widget> widgets = images.map<Widget>((i) => CarouselPage(i)).toList(growable: false);
    return Carousel(images: widgets, centreDots: true);
  }

  Future<void> _loadAssets(BuildContext context) async {
    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: max,
        enableCamera: false,
        options: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } on PlatformException catch (e) {
      snack(context, e.message);
    }

    if (resultList != null && resultList.length > 0) {
      onSelectImages(resultList);
    }
  }
}
