import 'dart:typed_data';

import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class CarouselPage extends StatelessWidget {
  final Uint8List _data;

  CarouselPage(this._data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_data == null) return _loading(context);
    return Image.memory(
      this._data,
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }

  Widget _loading(context) {
    var size = MediaQuery.of(context).size.width - 30.0;
    return Container(
      color: Burnt.imgPlaceholderColor,
      width: size,
      height: size,
      child: Center(
        child: CircularProgressIndicator(),
      )
    );
  }
}
