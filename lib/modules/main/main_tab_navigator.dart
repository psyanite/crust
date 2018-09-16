import 'package:crust/modules/home/home_screen.dart';
import 'package:crust/modules/main/main_tabs/discover_tab.dart';
import 'package:crust/modules/main/main_tabs/stats_tab.dart';
import 'package:crust/presentation/crust_con_icons.dart';
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
      appBar: new PlatformAdaptiveAppBar(
          title: new Text(_title), platform: Theme.of(context).platform),
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
        children: <Widget>[new HomeScreen(), new StatsTab(), new DiscoverTab()],
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
  const TabItem(title: 'Home', icon: CrustCon.bubble_heart),
  const TabItem(title: 'Rewards', icon: CrustCon.present),
  const TabItem(title: 'New Post', icon: CrustCon.new_post),
  const TabItem(title: 'Favorites', icon: CrustCon.star),
  const TabItem(title: 'My Profile', icon: CrustCon.heart),
];
