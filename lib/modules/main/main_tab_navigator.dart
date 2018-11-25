import 'package:crust/components/crust_cons_icons.dart';
import 'package:crust/modules/home/home_screen.dart';
import 'package:crust/modules/my_profile/my_profile_tab.dart';
import 'package:crust/modules/screens/favorites_screen.dart';
import 'package:crust/modules/screens/new_post_screen.dart';
import 'package:crust/modules/screens/rewards_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainTabNavigatorState();
}

class MainTabNavigatorState extends State<MainTabNavigator> {
  PageController _tabController = new PageController();
  int _currentIndex = 0;
  Map<TabType, Tab> _tabs = {
    TabType.home: Tab(widget: HomeScreen(), icon: CrustCons.bread_heart),
    TabType.rewards: Tab(widget: RewardsScreen(), icon: CrustCons.present),
    TabType.newPost: Tab(widget: NewPostScreen(), icon: CrustCons.new_post),
    TabType.favorites: Tab(widget: FavoritesScreen(), icon: CrustCons.star),
    TabType.myProfile: Tab(widget: MyProfileTab(), icon: CrustCons.person)
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(controller: _tabController, onPageChanged: _onPageChanged, children: _tabs.values.map((t) => t.widget).toList()),
      bottomNavigationBar: Card(
          margin: const EdgeInsets.all(0.0),
          elevation: 24.0,
          child: CupertinoTabBar(
            border: null,
            backgroundColor: Colors.grey[50],
            activeColor: Color(0xFFFFAB40),
            inactiveColor: Color(0x44604B41),
            currentIndex: _currentIndex,
            onTap: _onTap,
            items: _tabs.values.map((t) => new BottomNavigationBarItem(icon: new Icon(t.icon))).toList(),
          )),
    );
  }

  _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  _onTap(int index) {
    _tabController.jumpToPage(index);
  }
}

enum TabType { home, rewards, newPost, favorites, myProfile }

class Tab {
  final String name;
  final Widget widget;
  final IconData icon;

  const Tab({this.name, this.widget, this.icon});
}
