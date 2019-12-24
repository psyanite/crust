import 'package:crust/state/comment/comment_state.dart';
import 'package:crust/state/error/error_state.dart';
import 'package:crust/state/feed/feed_state.dart';
import 'package:crust/state/me/favorite/favorite_state.dart';
import 'package:crust/state/me/follow/follow_state.dart';
import 'package:crust/state/me/me_state.dart';
import 'package:crust/state/reward/reward_state.dart';
import 'package:crust/state/store/store_state.dart';
import 'package:crust/state/user/user_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final MeState me;
  final FeedState feed;
  final FavoriteState favorite;
  final FollowState follow;
  final StoreState store;
  final UserState user;
  final RewardState reward;
  final CommentState comment;
  final ErrorState error;

  AppState({MeState me, FeedState feed, FavoriteState favorite, FollowState follow, StoreState store, UserState user, RewardState reward, CommentState comment, ErrorState error})
      : me = me ?? MeState.initialState(),
        feed = feed ?? FeedState.initialState(),
        favorite = favorite ?? FavoriteState.initialState(),
        follow = follow ?? FollowState.initialState(),
        store = store ?? StoreState.initialState(),
        user = user ?? UserState.initialState(),
        reward = reward ?? RewardState.initialState(),
        comment = comment ?? CommentState.initialState(),
        error = error ?? ErrorState();

  static AppState rehydrate(dynamic json) {
    if (json == null) return AppState();
    try {
      return AppState(
        me: json['me'] != null ? MeState.rehydrate(json['me']) : null
      );
    }
    catch (e, stack) {
      print('[ERROR] Could not deserialize json from persistor: $e, $stack');
      return AppState();
    }
  }

  // Used by persistor
  Map<String, dynamic> toJson() => { 'me': me.toPersist() };

  AppState copyWith({MeState me}) {
    return AppState(me: me ?? this.me);
  }

  @override
  String toString() {
    return '''{
      me: $me,
      feed: $feed,
      favorite: $favorite,
      follow: $follow,
      store: $store,
      user: $user,
      reward: $reward,
      comment: $comment,
      error: $error
    }''';
  }
}
