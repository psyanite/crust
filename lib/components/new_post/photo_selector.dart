import 'package:crust/components/carousel.dart';
import 'package:crust/components/new_post/carousel_page.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

class PhotoSelector extends StatefulWidget {
  @override
  _PhotoSelectorState createState() => _PhotoSelectorState();
}

class _PhotoSelectorState extends State<PhotoSelector> {
  List<Asset> images = List<Asset>();

  @override
  Widget build(BuildContext context) {
    var buttonText = images.length > 0 ? 'Change Photos' : 'Add Photos';
    var children = <Widget>[];
    if (images.length > 0) {
      children.add(_carousel());
    }
    children.add(
      SmallButton(
        onPressed: () => loadAssets(context),
        padding: EdgeInsets.only(left: 7.0, right: 12.0, top: 10.0, bottom: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.add,
              size: 16.0,
              color: Colors.white,
            ),
            Container(width: 2.0),
            Text(buttonText, style: TextStyle(fontSize: 16.0, color: Colors.white))
          ]),
      )
    );
    return Column(
      children: children,
    );
  }

  Widget _carousel() {
    final List<Widget> widgets = images.map<Widget>((image) => CarouselPage(image)).toList();
    return Carousel(images: widgets);
  }

  Future<void> loadAssets(BuildContext context) async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList = List<Asset>();

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 10,
        enableCamera: false,
        options: CupertinoOptions(takePhotoIcon: "chat"),
      );
    } on PlatformException catch (e) {
      snack(context, e.message);
    }

    if (!mounted) return;

    if (resultList != null && resultList.length > 0) {

    }
    setState(() {
      images = resultList;
    });
  }
}
