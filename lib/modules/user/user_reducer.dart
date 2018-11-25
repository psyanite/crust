import 'dart:collection';

import 'package:crust/models/user.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/user/user_state.dart';
import 'package:redux/redux.dart';

Reducer<UserState> userReducer = combineReducers([
  new TypedReducer<UserState, FetchUserByUserIdSuccess>(fetchUserSuccess),
]);

UserState fetchUserSuccess(UserState state, FetchUserByUserIdSuccess action) {
  var users = state.users;
  if (users == null) users = LinkedHashMap<int, User>();
  users.update(action.user.id, (user) => action.user, ifAbsent: () => action.user);
  return state.copyWith(users: users);
}
