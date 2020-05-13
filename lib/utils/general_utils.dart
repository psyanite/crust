import 'dart:collection';

import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:geocoder/geocoder.dart' as Geo;
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class Utils {
  static final shareBaseUrl = 'https://burntoast.page.link/?link=https://burntoast.com';

  static int strToInt(String str) {
    return str != null ? int.parse(str) : null;
  }

  static String buildEmail(String subject, String body) {
    var encodedSubject = Uri.encodeComponent(subject);
    var encodedBody = Uri.encodeComponent('Hi there,<br><br>$body');
    return 'mailto:burntoastfix@gmail.com?subject=$encodedSubject&body=$encodedBody';
  }

  static String validateUsername(String name) {
    if (name == null || name.isEmpty) {
      return 'Oops! Usernames can\'t be blank';
    }
    if (name.length > 24) {
      return 'Sorry, usernames have to be shorter than 24 characters';
    }
    var allow = '0123456789abcdefghijklmnopqrstuvwxyz._'.split('');
    if (!name.split('').every((char) => allow.contains(char))) {
      return 'Sorry, usernames can only have lowercase letters, numbers, underscores, and periods';
    }
    return null;
  }

  static String validateDisplayName(String name) {
    if (name == null || name.isEmpty) {
      return 'Oops! Display names can\'t be blank';
    }
    if (name.length > 12) {
      return 'Sorry, display names have to be shorter than 12 characters';
    }
    var allow = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
    if (!name.split('').every((char) => allow.contains(char))) {
      return 'Sorry, display names can only have letters';
    }
    return null;
  }

  static String buildStoreUrl(int id) {
    return '$shareBaseUrl/stores/?id=$id';
  }

  static String buildProfileUrl(int id) {
    return '$shareBaseUrl/profiles/?id=$id';
  }

  static String buildRewardUrl(String code) {
    return '$shareBaseUrl/rewards/?code=$code';
  }

  static String buildStoreQrCode(int id) {
    return ':stores:$id';
  }

  static String buildProfileQrCode(int id) {
    return ':profiles:$id';
  }

  static String buildRewardQrCode(String code) {
    return ':rewards:$code';
  }

  static List<dynamic> subset(Iterable<int> ids, LinkedHashMap<int, dynamic> map) {
    return ids == null || map == null ? null : ids.map((i) => map[i]).toList();
  }

  static Geo.Address defaultAddress =
      Geo.Address(coordinates: Geo.Coordinates(-33.794883, 151.268071), addressLine: 'Sydney', locality: 'Sydney, NSW', postalCode: '2000');

  static Future<Geo.Address> getGeoAddress(int timeout) async {
    try {
      var p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: timeout));
      var coords = Coordinates(p.latitude, p.longitude);
      var addresses = await Geocoder.local.findAddressesFromCoordinates(coords).timeout(Duration(seconds: timeout));
      var address = addresses != null && addresses.isNotEmpty ? addresses[0] : null;
      return address;
    } catch (e) {}
    return null;
  }

  static fetchUserData(Store<AppState> store) {
    store.dispatch(FetchFavorites());
    store.dispatch(FetchLoyaltyRewards());
    store.dispatch(FetchFollows());
    store.dispatch(FetchMyPosts());
  }
}
