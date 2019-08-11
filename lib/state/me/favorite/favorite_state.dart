import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class FavoriteState {
  final Set<int> rewards;
  final Set<int> stores;
  final Set<int> posts;

  FavoriteState({this.rewards, this.stores, this.posts});

  FavoriteState.initialState()
    : rewards = Set<int>(),
      stores = Set<int>(),
      posts = Set<int>();

  FavoriteState copyWith({
    Set<int> rewards,
    Set<int> stores,
    Set<int> posts,
  }) {
    return FavoriteState(
      rewards: rewards ?? this.rewards,
      stores: stores ?? this.stores,
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return '''{
        rewards: ${rewards != null ? '${rewards.length} rewards' : null},
        stores: ${stores != null ? '${stores.length} stores' : null},
        posts: ${posts != null ? '${posts.length} posts' : null},
      }''';
  }
}
