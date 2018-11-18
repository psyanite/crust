import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/data/auth_repository.dart';
import 'package:crust/modules/error/error_actions.dart';
import 'package:crust/modules/post/data/post_repository.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAuthMiddleware(
    [AuthRepository authRepo = const AuthRepository(), PostRepository postRepo = const PostRepository()]) {
  final addUser = _addUser(authRepo);
  final fetchMyPosts = _fetchMyPosts(postRepo);

  return [
    TypedMiddleware<AppState, AddUserRequested>(addUser),
    TypedMiddleware<AppState, FetchMyPostsRequest>(fetchMyPosts),
  ];
}

Middleware<AppState> _addUser(AuthRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.addUser(action.user).then((userAccountId) {
      store.dispatch(LoginSuccess(action.user.copyWith(id: userAccountId)));
    }).catchError((e) => store.dispatch(RequestFailure(e)));

    next(action);
  };
}

Middleware<AppState> _fetchMyPosts(PostRepository repository) {
  return (Store<AppState> store, action, NextDispatcher next) {
    repository.fetchPostsByUserAccountId(action.userAccountId).then(
      (posts) {
        store.dispatch(FetchMyPostsSuccess(posts));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e)));

    next(action);
  };
}
