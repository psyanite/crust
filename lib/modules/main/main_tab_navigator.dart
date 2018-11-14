import 'package:crust/modules/home/home_screen.dart';
import 'package:crust/modules/my_profile/my_profile_screen.dart';
import 'package:crust/modules/favorites/favorites_screen.dart';
import 'package:crust/modules/new_post/new_post_screen.dart';
import 'package:crust/modules/rewards/rewards_screen.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/platform_adaptive.dart';
import 'package:crust/presentation/texts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabNavigator extends StatefulWidget {
  MainTabNavigator({Key key}) : super(key: key);

  @override
  State<MainTabNavigator> createState() => new MainTabNavigatorState();
}

class MainTabNavigatorState extends State<MainTabNavigator> {
  PageController _tabController;
  int _index;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Card(
        margin: const EdgeInsets.all(0.0),
        elevation: 24.0,
        child: new CupertinoTabBar(
          border: null,
          backgroundColor: Colors.grey[50],
          activeColor: Color(0xFFFFAB40),
          inactiveColor: Color(0x44604B41),
          currentIndex: _index,
          onTap: onTap,
          items: TabIcons.map((IconData icon) {
            return new BottomNavigationBarItem(
              icon: new Icon(icon),
            );
          }).toList(),
        )
      ),
      body: new PageView(
        controller: _tabController,
        onPageChanged: onTabChanged,
        children: <Widget>[new HomeScreen(), new RewardsScreen(), new NewPostScreen(), new FavoritesScreen(), new MyProfileScreen()],
      ),
    );
  }

  void onTap(int tab) {
    _tabController.jumpToPage(tab);
  }

  void onTabChanged(int tab) {
    setState(() {
      this._index = tab;
    });
  }
}

class TabItem {
  final IconData icon;

  const TabItem({this.icon});
}

const List<IconData> TabIcons = const <IconData>[
  CrustCons.bread_heart,
  CrustCons.present,
  CrustCons.new_post,
  CrustCons.star,
  CrustCons.person,
];
