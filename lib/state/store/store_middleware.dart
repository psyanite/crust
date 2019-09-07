import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:crust/state/store/store_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createStoreMiddleware([
  StoreService service = const StoreService(),
]) {
  final fetchTopStores = _fetchTopStores(service);
  final fetchStoreById = _fetchStoreById(service);
  final fetchRewardsByStoreId = _fetchRewardsByStoreId(service);

  return [
    TypedMiddleware<AppState, FetchTopStores>(fetchTopStores),
    TypedMiddleware<AppState, FetchStoreById>(fetchStoreById),
    TypedMiddleware<AppState, FetchRewardsByStoreId>(fetchRewardsByStoreId),
  ];
}

Middleware<AppState> _fetchTopStores(StoreService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchTopStores().then(
      (stores) {
        store.dispatch(FetchTopStoresSuccess(stores));
        store.dispatch(FetchStoresSuccess(stores));
      },
    ).catchError((e) => store.dispatch(RequestFailure("fetchTopStores ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _fetchStoreById(StoreService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchStoreById(action.storeId).then(
      (s) {
        store.dispatch(FetchStoreSuccess(s));
      },
    ).catchError((e) => store.dispatch(RequestFailure("fetchStoreById ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _fetchRewardsByStoreId(StoreService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchRewardsByStoreId(action.storeId).then(
      (rewards) {
        if (rewards != null) {
          store.dispatch(FetchRewardsSuccess(rewards));
          store.dispatch(FetchRewardsByStoreIdSuccess(action.storeId, rewards.map((r) => r.id).toList()));
        }
      },
    ).catchError((e) => store.dispatch(RequestFailure("fetchRewardsByStoreId ${e.toString()}")));
    next(action);
  };
}
