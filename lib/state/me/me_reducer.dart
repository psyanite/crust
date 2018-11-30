import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_state.dart';
import 'package:redux/redux.dart';

Reducer<MeState> authReducer = combineReducers([
  new TypedReducer<MeState, LoginSuccess>(loginSuccessReducer),
  new TypedReducer<MeState, Logout>(logoutReducer),
  new TypedReducer<MeState, FetchMyPostsSuccess>(fetchMyPostsReducer),
]);

MeState loginSuccessReducer(MeState state, LoginSuccess action) {
  return new MeState().copyWith(user: action.user);
}

MeState logoutReducer(MeState state, Logout action) {
  return new MeState();
}

MeState fetchMyPostsReducer(MeState state, FetchMyPostsSuccess action) {
  return state.copyWith(user: state.user.copyWith(posts: action.posts));
}
