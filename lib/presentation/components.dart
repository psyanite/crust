import 'package:crust/models/post.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class BackArrow extends StatelessWidget {
  final Color color;

  BackArrow({Key key, this.color = Burnt.textBodyColor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(CrustCons.back, color: color, size: 30.0),
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
      )})
      : super(key: key);

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

  WhiteButton({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: InkWell(
        splashColor: Burnt.primaryLight,
        onTap: onPressed,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(2.0)),
            boxShadow: [BoxShadow(color: Color(0x10000000), offset: Offset(5.0, 5.0), blurRadius: 10.0, spreadRadius: 1.0)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(text, style: TextStyle(fontSize: 20.0, color: Burnt.primary)),
            ],
          ),
        ),
      ),
    );
  }
}

class BottomButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  BottomButton({Key key, this.text, this.onPressed}) : super(key: key);

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
  final IconData icon;
  final double iconSize;
  final String text;
  final Function onPressed;
  final double padding;
  final double fontSize;

  SolidButton({Key key, this.icon, this.iconSize, this.text, this.onPressed, this.padding, this.fontSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: padding ?? 20.0),
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
            if (icon != null) Icon(icon, size: iconSize ?? 20.0, color: Colors.white),
            if (icon != null) Container(width: 8.0),
            Text(text, style: TextStyle(fontSize: fontSize ?? 22.0, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}

class HollowButton extends StatelessWidget {
  final Function onTap;
  final List<Widget> children;
  final double padding;

  HollowButton({Key key, this.onTap, this.children, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Burnt.splashOrange,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(color: Color(0xFFFFD173), width: 1.0, style: BorderStyle.solid), borderRadius: BorderRadius.circular(2.0)),
        padding: EdgeInsets.symmetric(vertical: padding ?? 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}

class LoadingCenter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class SliverCenter extends StatelessWidget {
  final Widget child;

  SliverCenter({Key key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        child: Center(
          child: child,
        ),
      ),
    );
  }
}

class LoadingSliver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverCenter(
      child: CircularProgressIndicator(),
    );
  }
}

class CenterTextSliver extends StatelessWidget {
  final String text;

  CenterTextSliver({Key key, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Center(
          child: Text(text, textAlign: TextAlign.center),
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

  ScoreIcon({Key key, this.score, this.size = 25.0, this.name, this.opacity = 1.0}) : super(key: key);

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
    return Column(children: <Widget>[
      Opacity(
        key: UniqueKey(),
        opacity: opacity,
        child: SvgPicture.asset(
          assetName,
          key: UniqueKey(),
          width: size,
          height: size,
        ),
      ),
      if (name != null) _name()
    ]);
  }

  Widget _name() {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0),
      child: Text(name),
    );
  }
}

class HeartIcon extends StatelessWidget {
  final bool isHollow;
  final double size;

  HeartIcon({Key key, this.isHollow, this.size = 25.0}) : super(key: key);

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
