import 'dart:typed_data';

import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final Uint8List _data;

  ImagePreview(this._data, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (_data == null) return _loading(context);
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        height: MediaQuery.of(context).size.width - 30.0,
        decoration: BoxDecoration(
          color: Burnt.imgPlaceholderColor,
          image: DecorationImage(fit: BoxFit.cover, image: MemoryImage(_data)),
        ),
      ),
    );
  }

  Widget _loading(context) {
    var size = MediaQuery.of(context).size.width - 30.0;
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0),
      child: Container(
        color: Burnt.imgPlaceholderColor,
        width: size,
        height: size,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
