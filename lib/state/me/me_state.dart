import 'package:crust/models/search.dart';
import 'package:crust/models/user.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart' as Geo;
import 'package:meta/meta.dart';

final List<SearchHistoryItem> defaultSearchHistory =
    SearchService.Cuisines.map((c) => SearchHistoryItem(type: SearchHistoryItemType.cuisine, cuisineName: c)).toList();

@immutable
class MeState {
  final User user;
  final List<SearchHistoryItem> searchHistory;
  final Geo.Address address;

  MeState({this.user, searchHistory, this.address}) : this.searchHistory = searchHistory ?? defaultSearchHistory;

  MeState.initialState()
      : user = null,
        searchHistory = defaultSearchHistory,
        address = null;

  MeState copyWith({
    User user,
    List<SearchHistoryItem> searchHistory,
    Geo.Address address,
  }) {
    return MeState(
      user: user ?? this.user,
      searchHistory: searchHistory ?? this.searchHistory,
      address: address ?? this.address,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) {
    var user = json['user'];
    var searchHistory = json['searchHistory'];
    var a = json['address'];
    return MeState(
        user: user != null ? User.rehydrate(user) : null,
        searchHistory: searchHistory != null ? searchHistory.map<SearchHistoryItem>((i) => SearchHistoryItem.rehydrate(i)).toList() : null,
        address: a != null
            ? Geo.Address(
                coordinates: Geo.Coordinates(a['lat'], a['lng']),
                addressLine: a['addressLine'],
                postalCode: a['postcode'],
                locality: a['locality'],
              )
            : null);
  }

  Map<String, dynamic> toPersist() {
    var address = this.address;
    return <String, dynamic>{
      'user': this.user?.toPersist(),
      'searchHistory': this.searchHistory?.map((i) => i.toPersist())?.toList(),
      'address': address != null
          ? <String, dynamic>{
              'lat': address.coordinates.latitude,
              'lng': address.coordinates.longitude,
              'addressLine': address.addressLine,
              'postcode': address.postalCode,
              'locality': address.locality,
            }
          : null
    };
  }

  @override
  String toString() {
    return '''{
        user: $user, 
        searchHistory: ${searchHistory?.length}, 
        address: ${address?.addressLine},
      }''';
  }
}
