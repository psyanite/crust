import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewModeIcon extends StatelessWidget {
  final Function toggleLayout;

  ViewModeIcon({Key key, this.toggleLayout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
        splashColor: Colors.transparent,
        padding: EdgeInsets.all(0.0),
        icon: Icon(CrustCons.view_mode),
        color: Burnt.lightGrey,
        iconSize: 15.0,
        onPressed: toggleLayout);
  }
}
