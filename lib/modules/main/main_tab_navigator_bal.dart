//import 'package:crust/modules/my_profile/test_screen.dart';
//import 'package:crust/modules/new_post/new_post_screen.dart';
//import 'package:crust/presentation/crust_cons_icons.dart';
//import 'package:flutter/cupertino.dart';
//import 'package:flutter/material.dart';
//
//class MainTabNavigator extends StatefulWidget {
//  MainTabNavigator({Key key}) : super(key: key);
//
//  @override
//  State<MainTabNavigator> createState() => new MainTabNavigatorState();
//}
//
//class MainTabNavigatorState extends State<MainTabNavigator> {
//  PageController _tabController;
//  TabType _currentTab;
//  int _currentIndex;
//  Map<TabType, Tab> _tabs;
//
//  @override
//  void initState() {
//    super.initState();
//    _tabController = new PageController();
//    _currentIndex = 0;
//    _currentTab = TabType.home;
//    _tabs = {
//      TabType.home: Tab(screen: _buildMyProfileOffStage(), icon: CrustCons.bread_heart),
//      TabType.rewards: Tab(screen: _buildMyProfileOffStage(), icon: CrustCons.present),
//      TabType.newPost: Tab(screen: _buildMyProfileOffStage(), icon: CrustCons.new_post),
//      TabType.favorites: Tab(screen: _buildMyProfileOffStage(), icon: CrustCons.star),
//      TabType.myProfile: Tab(screen: _buildMyProfileOffStage(), icon: CrustCons.person)
//    };
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return WillPopScope(
//      onWillPop: () async => !await _tabs[_currentTab].navigatorKey.currentState.maybePop(),
//      child: Scaffold(
//        bottomNavigationBar: new Card(
//          margin: const EdgeInsets.all(0.0),
//          elevation: 24.0,
//          child: new CupertinoTabBar(
//            border: null,
//            backgroundColor: Colors.grey[50],
//            activeColor: Color(0xFFFFAB40),
//            inactiveColor: Color(0x44604B41),
//            onTap: _onTap,
//            items: _tabs.values.map((t) => new BottomNavigationBarItem(icon: new Icon(t.icon))).toList(),
//          )),
////            body: new PageView(
////              controller: _tabController,
////              onPageChanged: _onPageChanged,
////              children: _tabs.values.map((t) => t.screen).toList(),
////            )
//        body: Stack(
//          children: <Widget>[
//            _buildMyProfileOffStage(),
//            _buildMyProfileOffStage(),
//          ],
//        )
//
//
//      ));
//  }
//
//  Route _getRoute(RouteSettings settings) {
//    switch (settings.name) {
//      default:
//        return new MaterialPageRoute(
//          settings: settings,
//          builder: (BuildContext context) => new NewPostScreen(),
//        );
//    }
//  }
//
//  void _onTap(int index) {
//    _tabController.jumpToPage(index);
//  }
//
//  void _onPageChanged(int index) {
//    setState(() {
//      _currentIndex = index;
//      _currentTab = _tabs.keys.elementAt(index);
//    });
//  }
//}
