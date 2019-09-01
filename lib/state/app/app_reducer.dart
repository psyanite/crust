import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_reducer.dart';
import 'package:crust/state/error/error_reducer.dart';
import 'package:crust/state/feed/feed_reducer.dart';
import 'package:crust/state/me/favorite/favorite_reducer.dart';
import 'package:crust/state/me/follow/follow_reducer.dart';
import 'package:crust/state/me/me_reducer.dart';
import 'package:crust/state/reward/reward_reducer.dart';
import 'package:crust/state/store/store_reducer.dart';
import 'package:crust/state/user/user_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
    me: meReducer(state.me, action),
    feed: feedReducer(state.feed, action),
    favorite: favoriteReducer(state.favorite, action),
    follow: followReducer(state.follow, action),
    store: storeReducer(state.store, action),
    user: userReducer(state.user, action),
    reward: rewardReducer(state.reward, action),
    comment: commentReducer(state.comment, action),
    error: errorReducer(state.error, action),
  );
}
