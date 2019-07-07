import 'package:crust/components/my_profile/my_profile_tab.dart';
import 'package:crust/components/new_post/select_store_screen.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/components/screens/home_screen.dart';
import 'package:crust/components/screens/favorites_screen.dart';
import 'package:crust/components/rewards_screen/rewards_screen.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainTabNavigatorState();
}

class MainTabNavigatorState extends State<MainTabNavigator> {
  PageController _pageCtrl = PageController();
  int _currentIndex = 0;
  Map<TabType, Tab> _tabs = {
    TabType.home: Tab(widget: HomeScreen(), icon: CrustCons.bread_heart),
    TabType.rewards: Tab(widget: RewardsScreen(), icon: CrustCons.present),
    TabType.newPost: Tab(widget: SelectStoreScreen(), icon: CrustCons.new_post),
    TabType.favorites: Tab(widget: FavoritesScreen(), icon: CrustCons.heart),
    TabType.myProfile: Tab(widget: MyProfileTab(), icon: CrustCons.person)
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(controller: _pageCtrl, onPageChanged: _onPageChanged, children: _tabs.values.map((t) => t.widget).toList()),
        bottomNavigationBar: Card(
            margin: const EdgeInsets.all(0.0),
            elevation: 24.0,
            child: CupertinoTabBar(
              border: null,
              backgroundColor: Burnt.paper,
              activeColor: Burnt.primary,
              inactiveColor: Burnt.lightGrey,
              currentIndex: _currentIndex,
              onTap: _onTap,
              items: _tabs.values.map((t) => new BottomNavigationBarItem(icon: Icon(t.icon))).toList(),
            )),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (_pageCtrl.page.round() == _pageCtrl.initialPage) {
      return Future(() => true);
    } else {
      return _pageCtrl.previousPage(
        duration: Duration(milliseconds: 200),
        curve: Curves.linear,
      );
    }
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _onTap(int index) {
    _pageCtrl.jumpToPage(index);
  }
}

enum TabType { home, rewards, newPost, favorites, myProfile }

class Tab {
  final String name;
  final Widget widget;
  final IconData icon;

  const Tab({this.name, this.widget, this.icon});
}
