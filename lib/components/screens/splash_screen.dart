import 'dart:async';

import 'package:crust/main.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  initState() {
    super.initState();
    _startTimer();
  }

  _startTimer() async {
    return Timer(Duration(seconds: 3), () {
      Navigator.popAndPushNamed(context, MainRoutes.root);
      Navigator.pop(context);
    });
  }

//  _getSuburb(Function setSuburb) async {
//    return Timer(Duration(seconds: 1), () async {
//      var enabled = await Geolocator().isLocationServiceEnabled();
//      if (enabled == false) return;
//      var p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: 5));
//      var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(p.latitude, p.longitude)).timeout(Duration(seconds: 5));
//      if (addresses.isNotEmpty) {
//        var a = addresses[0];
//        var result = await SearchService.findSuburbByName(a.locality);
//        if (result != null) {
//          setSuburb(result);
//          return;
//        }
//        var results = await SearchService.findSuburbsByQuery(a.locality, a.postalCode);
//        if (results.isNotEmpty) {
//          setSuburb(results[0]);
//          return;
//        }
//      }
//    });
//  }

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return StoreConnector<AppState, int>(
      onInit: (Store<AppState> store) {
        store.dispatch(FetchTopStores());
        store.dispatch(FetchTopRewards());
        if (store.state.me.user != null) {
          store.dispatch(FetchFavorites());
          store.dispatch(FetchFollows());
        }
        store.dispatch(FetchFeed());
        store.dispatch(FetchMyPosts());
        store.dispatch(FetchFavorites());
//        _getSuburb((s) => store.dispatch(SetMySuburb(s)));
      },
      converter: (Store<AppState> store) => 1,
      builder: (BuildContext context, int props) {
        return _presenter();
      },
    );
  }

  Widget _presenter() {
    return Scaffold(
      body: Container(
        child: Center(
          child: Image.asset('assets/images/loading-icon.png', height: 200.0),
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0, 0.6, 1.0],
            colors: [Color(0xFFffc86b), Color(0xFFffab40), Color(0xFFc45d35)],
          ),
        ),
      ),
    );
  }
}
