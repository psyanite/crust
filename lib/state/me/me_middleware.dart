import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMeMiddleware([MeService meService = const MeService(), PostService postService = const PostService()]) {
  final addUser = _addUser(meService);
  final setTagline = _setTagline(meService);
  final deleteTagline = _deleteTagline(meService);

  return [
    TypedMiddleware<AppState, AddUser>(addUser),
    TypedMiddleware<AppState, SetMyTagline>(setTagline),
    TypedMiddleware<AppState, DeleteMyTagline>(deleteTagline),
  ];
}

Middleware<AppState> _addUser(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.addUser(action.me).then((userId) {
      store.dispatch(LoginSuccess(action.me.copyWith(id: userId)));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _setTagline(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.setTagline(userId: store.state.me.user.id, tagline: action.tagline).then((tagline) {
      store.dispatch(SetMyTaglineSuccess(tagline));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _deleteTagline(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.deleteTagline(store.state.me.user.id).then((result) {
      if (result == true) {
        store.dispatch(DeleteMyTaglineSuccess());
      } else {
        store.dispatch(RequestFailure('Delete tagline request result was false'));
      }
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}
