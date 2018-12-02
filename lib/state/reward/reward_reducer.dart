import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_state.dart';
import 'package:redux/redux.dart';

Reducer<RewardState> rewardReducer = combineReducers([
  new TypedReducer<RewardState, FetchRewardsSuccess>(fetchRewardsSuccess),
]);

RewardState fetchRewardsSuccess(RewardState state, FetchRewardsSuccess action) {
  return state.copyWith(rewards: action.rewards);
}
