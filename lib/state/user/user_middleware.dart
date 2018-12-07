import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/user/user_actions.dart';
import 'package:crust/state/user/user_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createUserMiddleware([
  UserService service = const UserService(),
]) {
  final fetchUserByUserId = _fetchUserByUserId(service);

  return [
    TypedMiddleware<AppState, FetchUserByUserIdRequest>(fetchUserByUserId),
  ];
}

Middleware<AppState> _fetchUserByUserId(UserService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchUserByUserId(action.userId).then(
      (user) {
        store.dispatch(FetchUserByUserIdSuccess(user));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}
