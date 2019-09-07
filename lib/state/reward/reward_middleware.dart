import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createRewardMiddleware([
  RewardService service = const RewardService(),
]) {
  final fetchNearMe = _fetchNearMe(service);
  final fetchTopRewards = _fetchTopRewards(service);

  return [
    TypedMiddleware<AppState, FetchRewardsNearMe>(fetchNearMe),
    TypedMiddleware<AppState, FetchTopRewards>(fetchTopRewards),
  ];
}

Middleware<AppState> _fetchNearMe(RewardService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchRewards(limit: action.limit, offset: action.offset).then(
      (rewards) {
        store.dispatch(FetchRewardsSuccess(rewards));
        store.dispatch(FetchRewardsNearMeSuccess(rewards.where((r) => r.isExpired() == false).map((r) => r.id).toList()));
      },
    ).catchError((e) => store.dispatch(RequestFailure("fetchNearMe ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _fetchTopRewards(RewardService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchTopRewards().then(
      (rewards) {
        store.dispatch(FetchTopRewardsSuccess(rewards));
        store.dispatch(FetchRewardsSuccess(rewards));
      },
    ).catchError((e) => store.dispatch(RequestFailure("fetchTopRewards ${e.toString()}")));
    next(action);
  };
}
