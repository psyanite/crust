import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createRewardMiddleware([
  RewardService service = const RewardService(),
]) {
  final fetchTopRewards = _fetchTopRewards(service);
  final fetchRedeemed = _fetchRedeemed(service);
  final fetchLoyalty = _fetchLoyalty(service);

  return [
    TypedMiddleware<AppState, FetchTopRewards>(fetchTopRewards),
    TypedMiddleware<AppState, FetchRedeemedRewards>(fetchRedeemed),
    TypedMiddleware<AppState, FetchLoyaltyRewards>(fetchLoyalty),
  ];
}

Middleware<AppState> _fetchTopRewards(RewardService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchTopRewards().then((rewards) {
      store.dispatch(FetchTopRewardsSuccess(rewards));
      store.dispatch(FetchRewardsSuccess(rewards));
    }).catchError((e) => store.dispatch(RequestFailure('fetchTopRewards $e')));
    next(action);
  };
}

Middleware<AppState> _fetchRedeemed(RewardService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchRedeemedRewards(store.state.me.user.id).then((userRewards) {
      store.dispatch(FetchUserRewardsSuccess(userRewards));
    }).catchError((e) => store.dispatch(RequestFailure('fetchRedeemed $e')));
    next(action);
  };
}

Middleware<AppState> _fetchLoyalty(RewardService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchLoyaltyRewards(store.state.me.user.id).then((rewards) {
      if (rewards != null) store.dispatch(FetchLoyaltyRewardsSuccess(rewards));
    }).catchError((e) => store.dispatch(RequestFailure('fetchLoyaltyRewards $e')));
    next(action);
  };
}
