import 'package:crust/presentation/components.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final Function onFavorite;
  final Function onUnfavorite;
  final bool isFavorited;
  final double padding;
  final double size;

  FavoriteButton({Key key, this.onFavorite, this.onUnfavorite, this.isFavorited, this.padding = 15.0, this.size = 20.0}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () { isFavorited ? onUnfavorite() : onFavorite(); },
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: HeartIcon(isHollow: !isFavorited, size: size),
      ),
    );
  }
}