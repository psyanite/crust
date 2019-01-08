import 'package:crust/models/post.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:crust/presentation/theme.dart';
import 'package:flutter_svg/svg.dart';

class BackArrow extends StatelessWidget {
  final Color color;

  BackArrow({Key key, this.color = Burnt.textBody});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CrustCons.back, color: color),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

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
      onPressed: onPressed,
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
      onPressed: onPressed,
    );
  }
}

class LoadingCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
      ),
    );
  }
}

class LoadingSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: new CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ),
    );
  }
}

class ScoreIcon extends StatelessWidget {
  final Score score;
  final double size;
  final String name;

  ScoreIcon({Key key, this.score, this.size = 25.0, this.name});

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
        width: size,
        height: size,
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

class HeartIcon extends StatelessWidget {
  final bool isHollow;
  final double size;

  HeartIcon({Key key, this.isHollow, this.size = 25.0});

  @override
  Widget build(BuildContext context) {
    var assetName = isHollow ? 'assets/svgs/heart-hollow.svg' : 'assets/svgs/heart-filled.svg';
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
    );
  }
}

snack(context, text) {
  final snackBar = SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: 'OK',
      onPressed: () {},
    ),
  );
  Scaffold.of(context).showSnackBar(snackBar);
}