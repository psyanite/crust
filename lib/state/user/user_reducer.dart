import 'package:crust/state/user/user_actions.dart';
import 'package:crust/state/user/user_state.dart';
import 'package:redux/redux.dart';

Reducer<UserState> userReducer = combineReducers([
  new TypedReducer<UserState, FetchUserByUserIdSuccess>(fetchUserSuccess),
]);

UserState fetchUserSuccess(UserState state, FetchUserByUserIdSuccess action) {
  return state.addUser(action.user);
}
