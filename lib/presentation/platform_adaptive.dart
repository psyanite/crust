import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData getTheme(context) => ThemeData(
      primarySwatch: Burnt.materialPrimary,
      accentColor: Burnt.materialPrimary,
      fontFamily: Burnt.fontBase,
      cursorColor: Burnt.primary,
      textTheme: Theme.of(context)
          .textTheme
          .apply(
            bodyColor: Burnt.textBodyColor,
            displayColor: Burnt.textBodyColor,
            fontFamily: Burnt.fontBase,
          )
          .merge(TextTheme(body1: TextStyle(fontSize: 18.0))),
    );

/// App bar that uses iOS styling on iOS
class PlatformAdaptiveAppBar extends AppBar {
  PlatformAdaptiveAppBar(
      {Key key,
      TargetPlatform platform,
      List<Widget> actions,
      Widget title,
      Widget body,
      Widget bottom,
      Color backgroundColor,
      bool centerTitle,
      IconThemeData iconTheme,
      TextTheme textTheme})
      : super(
            key: key,
            elevation: platform == TargetPlatform.iOS ? 0.0 : 4.0,
            title: title,
            actions: actions,
            bottom: bottom,
            backgroundColor: backgroundColor,
            centerTitle: centerTitle ?? true,
            iconTheme: iconTheme,
            textTheme: textTheme);
}

/// Button that is Material on Android and Cupertino on iOS
/// On Android an icon button; on iOS, text is used
class PlatformAdaptiveButton extends StatelessWidget {
  PlatformAdaptiveButton({Key key, this.child, this.icon, this.onPressed}) : super(key: key);
  final Widget child;
  final Widget icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return new CupertinoButton(
        child: child,
        onPressed: onPressed,
      );
    } else {
      return new IconButton(
        icon: icon,
        onPressed: onPressed,
      );
    }
  }
}

// Bottom navigation bar that is Material on Android and Cupertino on iOS.
class PlatformAdaptiveBottomBar extends StatelessWidget {
  PlatformAdaptiveBottomBar({Key key, this.activeColor, this.currentIndex, this.onTap, this.items}) : super(key: key);
  final Color activeColor;
  final int currentIndex;
  final Function onTap;
  final List<BottomNavigationBarItem> items;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return new CupertinoTabBar(
        activeColor: activeColor,
        currentIndex: currentIndex,
        onTap: onTap,
        items: items,
      );
    } else {
      return new BottomNavigationBar(
        currentIndex: currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: onTap,
        items: items,
      );
    }
  }
}

class PlatformAdaptiveContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;

  PlatformAdaptiveContainer({Key key, this.child, this.margin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: child,
      margin: margin,
      decoration: Theme.of(context).platform == TargetPlatform.iOS
          ? new BoxDecoration(border: new Border(top: BorderSide(color: Colors.grey[200])))
          : null,
    );
  }
}

class PlatformChooser extends StatelessWidget {
  PlatformChooser({Key key, this.iosChild, this.defaultChild});

  final Widget iosChild;
  final Widget defaultChild;

  @override
  Widget build(BuildContext context) {
    if (Theme.of(context).platform == TargetPlatform.iOS) return iosChild;
    return defaultChild;
  }
}
