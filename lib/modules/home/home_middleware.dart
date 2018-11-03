import 'package:crust/app/app_state.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/home_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createHomeMiddleware([
  HomeRepository repository = const HomeRepository(),
]) {
  final fetchStores = _fetchStores(repository);

  return [
    TypedMiddleware<AppState, FetchStoresRequest>(fetchStores),
  ];
}

Middleware<AppState> _fetchStores(HomeRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.fetchStores().then(
      (stores) {
        store.dispatch(FetchStoresSuccess(stores));
      },
    ).catchError((e) => store.dispatch(FetchStoresFailure(e)));

    next(action);
  };
}
