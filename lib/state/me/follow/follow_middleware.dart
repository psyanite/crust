import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:crust/state/me/follow/follow_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createFollowMiddleware([FollowService followService = const FollowService()]) {
  final fetchFollows = _fetchFollows(followService);
  final followUser = _followUser(followService);
  final followStore = _followStore(followService);
  final unfollowUser = _unfollowUser(followService);
  final unfollowStore = _unfollowStore(followService);

  return [
    TypedMiddleware<AppState, FetchFollows>(fetchFollows),
    TypedMiddleware<AppState, FollowUser>(followUser),
    TypedMiddleware<AppState, FollowStore>(followStore),
    TypedMiddleware<AppState, UnfollowUser>(unfollowUser),
    TypedMiddleware<AppState, UnfollowStore>(unfollowStore),
  ];
}

Middleware<AppState> _fetchFollows(FollowService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.fetchFollowedUsers(user.id).then((stores) {
        store.dispatch(FetchFollowedUsersSuccess(stores));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
      service.fetchFollowedStores(user.id).then((stores) {
        store.dispatch(FetchFollowedStoresSuccess(stores));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _followUser(FollowService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.followUser(userId: action.userId, followerId: user.id).then((userId) {
        store.dispatch(FollowUserSuccess(userId));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _followStore(FollowService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.followStore(storeId: action.storeId, followerId: user.id).then((storeId) {
        store.dispatch(FollowStoreSuccess(storeId));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _unfollowUser(FollowService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.unfollowUser(userId: action.userId, followerId: user.id).then((userId) {
        store.dispatch(UnfollowUserSuccess(userId));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _unfollowStore(FollowService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.unfollowStore(storeId: action.storeId, followerId: user.id).then((storeId) {
        store.dispatch(UnfollowStoreSuccess(storeId));
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}
