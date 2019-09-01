import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

final List<SearchHistoryItem> defaultSearchHistory =
    SearchService.Cuisines.map((c) => SearchHistoryItem(type: SearchHistoryItemType.cuisine, cuisineName: c)).toList();

final SearchLocationItem defaultLocation = SearchLocationItem(name: 'Sydney', description: 'NSW');

@immutable
class MeState {
  final User user;
  final List<SearchHistoryItem> searchHistory;
  final SearchLocationItem location;
  final Suburb suburb;

  MeState({this.user, searchHistory, location, this.suburb})
      : this.searchHistory = searchHistory ?? defaultSearchHistory,
        this.location = location ?? defaultLocation;

  MeState.initialState()
      : user = null,
        searchHistory = defaultSearchHistory,
        location = defaultLocation,
        suburb = null;

  MeState copyWith({
    User user,
    UserReward userReward,
    List<SearchHistoryItem> searchHistory,
    SearchLocationItem location,
    Suburb suburb,
  }) {
    return MeState(
      user: user ?? this.user,
      searchHistory: searchHistory ?? this.searchHistory,
      location: location ?? this.location,
      suburb: suburb ?? this.suburb,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) {
    var user = json['user'];
    var searchHistory = json['searchHistory'];
    var location = json['location'];
    var suburb = json['suburb'];
    return MeState(
      user: user != null ? User.rehydrate(user) : null,
      searchHistory: searchHistory != null ? searchHistory.map<SearchHistoryItem>((i) => SearchHistoryItem.rehydrate(i)).toList() : null,
      location: location != null ? SearchLocationItem.rehydrate(location) : null,
      suburb: suburb != null ? Suburb.rehydrate(suburb) : null,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'user': this.user?.toPersist(),
      'searchHistory': this.searchHistory?.map((i) => i.toPersist())?.toList(),
      'location': this.location?.toPersist(),
//      'suburb': this.suburb?.toPersist(),
    };
  }

  @override
  String toString() {
    return '''{
        user: $user, searchHistory: ${searchHistory?.length}, location: ${location?.name}, suburb: ${suburb?.name},
      }''';
  }
}
