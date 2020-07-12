import 'package:crust/components/common/main_tab_navigator.dart';

class Navi {
  static final Navi _singleton = Navi._internal();
  static MainTabNavigatorState _mainTabNav;

  Navi._internal();

  MainTabNavigatorState getMainTabNav() => _mainTabNav;

  factory Navi({MainTabNavigatorState mainTabNav}) {
    if (mainTabNav != null && _mainTabNav != mainTabNav) {
      _mainTabNav = mainTabNav;
    }
    return _singleton;
  }
}
