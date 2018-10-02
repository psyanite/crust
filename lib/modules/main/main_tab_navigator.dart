import 'package:crust/modules/home/home_screen.dart';
import 'package:crust/modules/my_profile/my_profile_screen.dart';
import 'package:crust/modules/favorites/favorites_screen.dart';
import 'package:crust/modules/new_post/new_post_screen.dart';
import 'package:crust/modules/rewards/rewards_screen.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/platform_adaptive.dart';
import 'package:crust/presentation/texts.dart';
import 'package:flutter/material.dart';

class MainTabNavigator extends StatefulWidget {
  MainTabNavigator({Key key}) : super(key: key);

  @override
  State<MainTabNavigator> createState() => new MainTabNavigatorState();
}

class MainTabNavigatorState extends State<MainTabNavigator> {
  PageController _tabController;
  String _title;
  int _index;

  @override
  void initState() {
    super.initState();
    _tabController = new PageController();
    _title = TabItems[0].title;
    _index = 0;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new PlatformAdaptiveBottomBar(
        currentIndex: _index,
        onTap: onTap,
        items: TabItems.map((TabItem item) {
          return new BottomNavigationBarItem(
            title: new Text(
              item.title,
              style: textStyles['bottom_label'],
            ),
            icon: new Icon(item.icon),
          );
        }).toList(),
      ),
      body: new PageView(
        controller: _tabController,
        onPageChanged: onTabChanged,
        children: <Widget>[
          new HomeScreen(),
          new RewardsScreen(),
          new NewPostScreen(),
          new FavoritesScreen(),
          new MyProfileScreen()
        ],
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

    this._title = TabItems[tab].title;
  }
}

class TabItem {
  final String title;
  final IconData icon;

  const TabItem({this.title, this.icon});
}

const List<TabItem> TabItems = const <TabItem>[
  const TabItem(title: 'Home', icon: CrustCons.bread_heart),
  const TabItem(title: 'Rewards', icon: CrustCons.present),
  const TabItem(title: 'New Post', icon: CrustCons.new_post),
  const TabItem(title: 'Favorites', icon: CrustCons.star),
  const TabItem(title: 'My Profile', icon: CrustCons.person),
];
