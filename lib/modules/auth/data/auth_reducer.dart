import 'package:redux/redux.dart';

import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/data/auth_state.dart';

Reducer<AuthState> authReducer = combineReducers([
  new TypedReducer<AuthState, LoginSuccess>(loginSuccessReducer),
  new TypedReducer<AuthState, Logout>(logoutReducer),
  new TypedReducer<AuthState, FetchMyPostsSuccess>(fetchMyPostsReducer),
]);

AuthState loginSuccessReducer(AuthState auth, LoginSuccess action) {
  return new AuthState().copyWith(user: action.user);
}

AuthState logoutReducer(AuthState auth, Logout action) {
  return new AuthState();
}

AuthState fetchMyPostsReducer(AuthState auth, FetchMyPostsSuccess action) {
  return new AuthState().copyWith(posts: action.posts);
}


