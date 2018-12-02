import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_reducer.dart';
import 'package:crust/state/error/error_reducer.dart';
import 'package:crust/state/home/home_reducer.dart';
import 'package:crust/state/user/user_reducer.dart';
import 'package:crust/state/reward/reward_reducer.dart';

AppState appReducer(AppState state, action) {
  return AppState(
      me: authReducer(state.me, action),
      home: homeReducer(state.home, action),
      user: userReducer(state.user, action),
      reward: rewardReducer(state.reward, action),
      error: errorReducer(state.error, action));
}
