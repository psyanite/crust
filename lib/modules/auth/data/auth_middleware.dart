import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/data/auth_repository.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/home_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAuthMiddleware([
  AuthRepository repository = const AuthRepository(),
  HomeRepository homeRepo = const HomeRepository()
]) {
  final addUser = _addUser(repository);

  return [
    TypedMiddleware<AppState, AddUserRequested>(addUser),
  ];
}

Middleware<AppState> _addUser(AuthRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.addUser(action.user).then(
        (userAccountId) {
        store.dispatch(LoginSuccess(action.user.copyWith(id: userAccountId)));
      }
    ).catchError((e) => store.dispatch(RequestFailure(e)));

    next(action);
  };
}
