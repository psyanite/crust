import 'package:crust/services/firebase_messenger.dart';
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
  final setFcmToken = _setFcmToken(meService);

  return [
    TypedMiddleware<AppState, AddUser>(addUser),
    TypedMiddleware<AppState, SetMyTagline>(setTagline),
    TypedMiddleware<AppState, DeleteMyTagline>(deleteTagline),
    TypedMiddleware<AppState, CheckFcmToken>(setFcmToken),
  ];
}

Middleware<AppState> _addUser(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.addUser(action.user).then((userId) {
      store.dispatch(LoginSuccess(action.user.copyWith(id: userId)));
      store.dispatch(CheckFcmToken());
    }).catchError((e) => store.dispatch(RequestFailure('addUser $e')));
    next(action);
  };
}

Middleware<AppState> _setTagline(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.setTagline(userId: store.state.me.user.id, tagline: action.tagline).then((tagline) {
      store.dispatch(SetMyTaglineSuccess(tagline));
    }).catchError((e) => store.dispatch(RequestFailure('setTagline $e')));
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
    }).catchError((e) => store.dispatch(RequestFailure('deleteTagline $e')));
    next(action);
  };
}

Middleware<AppState> _setFcmToken(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var currentToken = store.state.me.user?.fcmToken;
    FirebaseMessenger().getToken().then((t) {
      if (t == null) store.dispatch(SendSystemError('Get FCM Token', 'FCM returned null token ${store.state.me.user?.username}'));
      else if ((currentToken == null || t != currentToken)) {
        service.setFcmToken(userId: store.state.me.user.id, token: t).then((result) {
          if (result == true) {
            store.dispatch(SetFcmToken(t));
          } else {
            store.dispatch(RequestFailure('Set Fcm Token request result was false'));
          }
        }).catchError((e) => store.dispatch(RequestFailure('setFcmToken $e')));
      }
    }).catchError((e) => store.dispatch(SendSystemError('Get FCM Token', 'Error for ${store.state.me.user.username}, $e')));
    next(action);
  };
}
