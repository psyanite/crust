import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_middleware.dart';
import 'package:crust/state/error/error_middleware.dart';
import 'package:crust/state/feed/feed_middleware.dart';
import 'package:crust/state/me/favorite/favorite_middleware.dart';
import 'package:crust/state/me/follow/follow_middleware.dart';
import 'package:crust/state/me/me_middleware.dart';
import 'package:crust/state/reward/reward_middleware.dart';
import 'package:crust/state/store/store_middleware.dart';
import 'package:crust/state/user/user_middleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  return <Middleware<AppState>>[]
    ..addAll(createCommentMiddleware())
    ..addAll(createErrorMiddleware())
    ..addAll(createFavoriteMiddleware())
    ..addAll(createFeedMiddleware())
    ..addAll(createFollowMiddleware())
    ..addAll(createMeMiddleware())
    ..addAll(createRewardMiddleware())
    ..addAll(createStoreMiddleware())
    ..addAll(createUserMiddleware());
}
