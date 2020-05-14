import 'package:crust/components/common/components.dart';
import 'package:flutter/material.dart';

class FavoriteButton extends StatelessWidget {
  final Function onFavorite;
  final Function onUnfavorite;
  final bool isFavorited;
  final EdgeInsets padding;
  final double size;

  FavoriteButton({Key key, this.onFavorite, this.onUnfavorite, this.isFavorited, this.padding, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () { isFavorited ? onUnfavorite() : onFavorite(); },
      child: Padding(
        padding: padding ?? EdgeInsets.all(0.0),
        child: HeartIcon(isHollow: !isFavorited, size: size ?? 20.0),
      ),
    );
  }
}