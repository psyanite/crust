import 'dart:async';
import 'dart:collection';

import 'package:crust/components/my_profile/my_profile_tab.dart';
import 'package:crust/components/new_post/select_store_screen.dart';
import 'package:crust/components/rewards/rewards_screen.dart';
import 'package:crust/components/screens/home_screen.dart';
import 'package:crust/components/stores/browse_stores_screen.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/services/firebase_messenger.dart';
import 'package:crust/services/navi.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainTabNavigator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MainTabNavigatorState();
}

class MainTabNavigatorState extends State<MainTabNavigator> {
  PageController _pageCtrl = PageController();
  Queue<int> _history;
  bool _lastActionWasGo;
  int _currentIndex = 0;
  Map<TabType, Tab> _tabs;

  @override
  initState() {
    super.initState();
    _history = Queue<int>();
    _history.addLast(0);
    _tabs = {
      TabType.home: Tab(index: 0, widget: HomeScreen(jumpToStoresTab), icon: CrustCons.heart),
      TabType.stores: Tab(index: 1, widget: BrowseStoresScreen(), icon: CrustCons.bread_heart),
      TabType.rewards: Tab(index: 2, widget: RewardsScreen(), icon: CrustCons.present),
      TabType.newPost: Tab(index: 3, widget: SelectStoreScreen(), icon: CrustCons.new_post),
      TabType.myProfile: Tab(index: 4, widget: MyProfileTab(), icon: CrustCons.person)
    };

    FirebaseMessenger(context: context);
    Navi(mainTabNav: this);
  }

  @override
  Widget build(BuildContext context) {
    if (_tabs == null) return Container();
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: PageView(
          controller: _pageCtrl,
          physics: NeverScrollableScrollPhysics(),
          onPageChanged: _onPageChanged,
          children: _tabs.values.map((t) => t.widget).toList(),
        ),
        bottomNavigationBar: Card(
          margin: EdgeInsets.all(0.0),
          elevation: 24.0,
          child: CupertinoTabBar(
            border: null,
            backgroundColor: Burnt.paper,
            activeColor: Burnt.primary,
            inactiveColor: Burnt.lightGrey,
            currentIndex: _currentIndex,
            onTap: _jumpToPage,
            items: _tabs.values.map((t) => BottomNavigationBarItem(icon: Icon(t.icon))).toList(),
          ),
        ),
      ),
    );
  }

  Future<bool> _onWillPop() {
    if (_history.length == 0) {
      return Future(() => true);
    } else {
      var history = Queue<int>.from(_history);
      if (_lastActionWasGo) history.removeLast();
      var previousPage = history.removeLast();
      setState(() {
        _history = history;
        _lastActionWasGo = false;
      });
      _pageCtrl.jumpToPage(previousPage);
      return Future(() => false);
    }
  }

  _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  _jumpToPage(int index) {
    if (_currentIndex == index) return;
    var history = Queue<int>.from(_history);
    history.addLast(index);
    setState(() {
      _history = history;
      _lastActionWasGo = true;
    });
    _pageCtrl.jumpToPage(index);
  }

  _jumpToTab(TabType tab) => _jumpToPage(_tabs[tab].index);

  jumpToHomeTab() => _jumpToTab(TabType.home);

  jumpToRewardsTab() => _jumpToTab(TabType.rewards);

  jumpToNewPostTab() => _jumpToTab(TabType.newPost);

  jumpToStoresTab() => _jumpToTab(TabType.stores);

  jumpToMyProfileTab() => _jumpToTab(TabType.myProfile);
}

enum TabType { home, rewards, newPost, stores, myProfile }

class Tab {
  final int index;
  final String name;
  final Widget widget;
  final IconData icon;

  const Tab({this.index, this.name, this.widget, this.icon});
}
