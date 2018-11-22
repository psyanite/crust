import 'package:redux/redux.dart';

import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:crust/modules/auth/data/me_state.dart';

Reducer<MeState> authReducer = combineReducers([
  new TypedReducer<MeState, LoginSuccess>(loginSuccessReducer),
  new TypedReducer<MeState, Logout>(logoutReducer),
  new TypedReducer<MeState, FetchMyPostsSuccess>(fetchMyPostsReducer),
]);

MeState loginSuccessReducer(MeState auth, LoginSuccess action) {
  return new MeState().copyWith(me: action.user);
}

MeState logoutReducer(MeState auth, Logout action) {
  return new MeState();
}

MeState fetchMyPostsReducer(MeState auth, FetchMyPostsSuccess action) {
  return auth.copyWith(posts: action.posts);
}


