import 'package:crust/app/app_state.dart';
import 'package:crust/modules/error/error_actions.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/home_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createHomeMiddleware([
  HomeService repository = const HomeService(),
]) {
  final fetchStores = _fetchStores(repository);

  return [
    TypedMiddleware<AppState, FetchStoresRequest>(fetchStores),
  ];
}

Middleware<AppState> _fetchStores(repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.fetchStores().then(
      (stores) {
        store.dispatch(FetchStoresSuccess(stores));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e)));

    next(action);
  };
}
