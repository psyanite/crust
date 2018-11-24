import 'package:crust/models/Post.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:crust/presentation/theme.dart';
import 'package:flutter_svg/svg.dart';

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

class LoadingSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: CupertinoActivityIndicator(),
        ),
      ),
    );
  }
}

class ScoreIcon extends StatelessWidget {
  final Score score;
  final double size;
  final String name;

  ScoreIcon({Key key, this.score, this.size, this.name});

  @override
  Widget build(BuildContext context) {
    var assetName;
    switch (score) {
      case (Score.bad):
        {
          assetName = 'assets/svgs/bread-bad.svg';
        }
        break;
      case (Score.okay):
        {
          assetName = 'assets/svgs/bread-okay.svg';
        }
        break;
      case (Score.good):
        {
          assetName = 'assets/svgs/bread-good.svg';
        }
        break;
      default:
        {
          return new Container();
        }
    }
    var children = <Widget>[
      SvgPicture.asset(
        assetName,
        width: size ?? 25.0,
        height: size ?? 25.0,
      )
    ];
    if (name != null) {
      children.add(Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Text(name),
      ));
    }
    return Column(children: children);
  }
}