import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:multi_image_picker/asset.dart';

class CarouselPage extends StatefulWidget {
  final Asset _asset;

  CarouselPage(
    this._asset, {
      Key key,
    }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CarouselPageState(this._asset);
}

class _CarouselPageState extends State<CarouselPage> {
  Asset _asset;
  _CarouselPageState(this._asset);

  @override
  void initState() {
    super.initState();
    _loadImage();
  }

  void _loadImage() async {
    await this._asset.requestOriginal(quality: 80);

    if (this.mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (null != this._asset.imageData) {
      return Image.memory(
        this._asset.imageData.buffer.asUint8List(),
        fit: BoxFit.cover,
        gaplessPlayback: true,
      );
    }

    return Container(
      color: Burnt.imgPlaceholderColor
    );
  }
}
