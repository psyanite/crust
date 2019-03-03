import 'package:crust/models/post.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackArrow extends StatelessWidget {
  final Color color;

  BackArrow({Key key, this.color = Burnt.textBodyColor});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CrustCons.back, color: color),
      onPressed: () => Navigator.of(context).pop(),
    );
  }
}

class SmallButton extends StatelessWidget {
  final Widget child;
  final Function onPressed;
  final EdgeInsetsGeometry padding;
  final Gradient gradient;

  SmallButton(
      {Key key,
      this.child,
      this.onPressed,
      this.padding,
      this.gradient = const LinearGradient(
        begin: Alignment.bottomLeft,
        end: Alignment.topRight,
        stops: [0, 0.6, 1.0],
        colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
      )});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: padding,
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(2.0)), gradient: gradient),
        child: child,
      ),
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
      color: Burnt.paper,
      padding: EdgeInsets.symmetric(vertical: 20.0),
      child: Text(text, style: TextStyle(fontSize: 22.0)),
      onPressed: onPressed,
    );
  }
}

class BottomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  BottomButton({Key key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0, 0.6, 1.0],
            colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
          )),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white, letterSpacing: 3.0)),
          ],
        ),
      ),
    );
  }
}

class SolidButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  SolidButton({Key key, this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            gradient: LinearGradient(
              begin: Alignment.bottomLeft,
              end: Alignment.topRight,
              stops: [0, 0.6, 1.0],
              colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
            )),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(text, style: TextStyle(fontSize: 22.0, color: Colors.white)),
          ],
        ),
      ),
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
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
          ),
        ),
      ),
    );
  }
}

class CenterTextSliver extends StatelessWidget {
  final String text;

  CenterTextSliver({Key key, this.text});

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: Text(text),
        ),
      ),
    );
  }
}

class ScoreIcon extends StatelessWidget {
  final double opacity;
  final Score score;
  final double size;
  final String name;

  ScoreIcon({Key key, this.score, this.size = 25.0, this.name, this.opacity = 1.0});

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
      Opacity(
        key: UniqueKey(),
        opacity: opacity,
        child: SvgPicture.asset(
          assetName,
          key: UniqueKey(),
          width: size,
          height: size,
        ),
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
