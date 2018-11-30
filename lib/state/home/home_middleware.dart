import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/home/home_actions.dart';
import 'package:crust/state/home/home_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createHomeMiddleware([
  HomeService service = const HomeService(),
]) {
  final fetchStores = _fetchStores(service);
  final fetchPostsByStoreId = _fetchPostsByStoreId(service);

  return [
    TypedMiddleware<AppState, FetchStoresRequest>(fetchStores),
    TypedMiddleware<AppState, FetchPostsByStoreIdRequest>(fetchPostsByStoreId),
  ];
}

Middleware<AppState> _fetchStores(HomeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchStores().then(
      (stores) {
        store.dispatch(FetchStoresSuccess(stores));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}

Middleware<AppState> _fetchPostsByStoreId(HomeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchPostsByStoreId(action.storeId).then(
      (posts) {
        store.dispatch(FetchPostsByStoreIdSuccess(action.storeId, posts));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}
