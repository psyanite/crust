import 'package:crust/models/search.dart';
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

  MeState({this.user, searchHistory, location})
      : this.searchHistory = searchHistory ?? defaultSearchHistory,
        this.location = location ?? defaultLocation;

  MeState.initialState()
      : user = null,
        searchHistory = defaultSearchHistory,
        location = defaultLocation;

  MeState copyWith({
    User user,
    UserReward userReward,
    List<SearchHistoryItem> searchHistory,
    SearchLocationItem location,
  }) {
    return MeState(
      user: user ?? this.user,
      searchHistory: searchHistory ?? this.searchHistory,
      location: location ?? this.location,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) {
    var user = json['user'];
    var searchHistory = json['searchHistory'];
    var location = json['location'];
    return MeState(
      user: user != null ? User.rehydrate(user) : null,
      searchHistory: searchHistory != null ? searchHistory.map<SearchHistoryItem>((i) => SearchHistoryItem.rehydrate(i)).toList() : null,
      location: location != null ? SearchLocationItem.rehydrate(location) : null,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'user': this.user?.toPersist(),
      'searchHistory': this.searchHistory?.map((i) => i.toPersist())?.toList(),
      'location': this.location?.toPersist(),
    };
  }

  @override
  String toString() {
    return '''{
        user: $user,
        searchHistory: ${searchHistory != null ? '${searchHistory.length} items' : null},
        location: $location,
      }''';
  }
}
