import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_state.dart';
import 'package:redux/redux.dart';

Reducer<RewardState> rewardReducer = combineReducers([
  new TypedReducer<RewardState, FetchRewardsSuccess>(fetchRewardsSuccess),
  new TypedReducer<RewardState, FetchRewardSuccess>(fetchRewardSuccess),
]);

RewardState fetchRewardsSuccess(RewardState state, FetchRewardsSuccess action) {
  return state.addRewards(action.rewards);
}

RewardState fetchRewardSuccess(RewardState state, FetchRewardSuccess action) {
  return state.addReward(action.reward);
}
