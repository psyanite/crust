import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_state.dart';
import 'package:redux/redux.dart';

Reducer<RewardState> rewardReducer = combineReducers([
  new TypedReducer<RewardState, FetchRewardsSuccess>(fetchRewardsSuccess),
  new TypedReducer<RewardState, FetchRewardSuccess>(fetchRewardSuccess),
  new TypedReducer<RewardState, FetchTopRewardsSuccess>(fetchTopRewardSuccess),
  new TypedReducer<RewardState, FetchRewardsNearMeSuccess>(fetchRewardsNearMeSuccess),
]);

RewardState fetchRewardsSuccess(RewardState state, FetchRewardsSuccess action) {
  return state.addRewards(action.rewards);
}

RewardState fetchRewardSuccess(RewardState state, FetchRewardSuccess action) {
  return state.addReward(action.reward);
}

RewardState fetchTopRewardSuccess(RewardState state, FetchTopRewardsSuccess action) {
  return state.setTopRewards(action.rewards);
}

RewardState fetchRewardsNearMeSuccess(RewardState state, FetchRewardsNearMeSuccess action) {
  return state.addNearMe(action.rewardIds);
}
