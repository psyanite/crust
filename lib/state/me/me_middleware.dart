import 'package:crust/state/post/post_service.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMeMiddleware([MeService meService = const MeService(), PostService postService = const PostService()]) {
  final addUser = _addUser(meService);
  final fetchMyPosts = _fetchMyPosts(postService);

  return [
    TypedMiddleware<AppState, AddUserRequested>(addUser),
    TypedMiddleware<AppState, FetchMyPostsRequest>(fetchMyPosts),
  ];
}

Middleware<AppState> _addUser(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.addUser(action.me).then((userAccountId) {
      store.dispatch(LoginSuccess(action.me.copyWith(storeId: userAccountId)));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}

Middleware<AppState> _fetchMyPosts(PostService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchPostsByUserAccountId(action.userAccountId).then(
      (posts) {
        store.dispatch(FetchMyPostsSuccess(posts));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));

    next(action);
  };
}
