import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/store/store_middleware.dart';
import 'package:crust/state/me/me_middleware.dart';
import 'package:crust/state/reward/reward_middleware.dart';
import 'package:crust/state/user/user_middleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  return <Middleware<AppState>>[]
    ..addAll(createMeMiddleware())
    ..addAll(createStoreMiddleware())
    ..addAll(createUserMiddleware())
    ..addAll(createRewardMiddleware());
}
