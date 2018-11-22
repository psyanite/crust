import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:crust/presentation/theme.dart';

class WhiteButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  WhiteButton({Key key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Burnt.primary,
      color: Burnt.background,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(text, style: TextStyle(fontSize: 22.0)),
      onPressed: () => onPressed(context),
    );
  }
}

class SolidButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  SolidButton({Key key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      textColor: Colors.white,
      color: Burnt.primary,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(text, style: TextStyle(fontSize: 22.0)),
      onPressed: () => onPressed(context),
    );
  }
}
