import 'package:crust/app/app_state.dart';
import 'package:crust/modules/error/error_actions.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/user/user_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUserMiddleware([
  UserService service = const UserService(),
]) {
  final fetchStores = _fetchStores(service);

  return [
    TypedMiddleware<AppState, FetchUserByUserIdRequest>(fetchStores),
  ];
}

Middleware<AppState> _fetchStores(UserService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchUserByUserId().then(
      (stores) {
        store.dispatch(FetchStoresSuccess(stores));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}
