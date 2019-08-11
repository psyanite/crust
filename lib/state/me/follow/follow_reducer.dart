import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:crust/state/me/follow/follow_state.dart';
import 'package:redux/redux.dart';

Reducer<FollowState> followReducer = combineReducers([
  new TypedReducer<FollowState, FetchFollowedUsersSuccess>(fetchFollowedUsers),
  new TypedReducer<FollowState, FetchFollowedStoresSuccess>(fetchFollowedStores),
  new TypedReducer<FollowState, FollowUserSuccess>(followUser),
  new TypedReducer<FollowState, FollowStoreSuccess>(followStore),
  new TypedReducer<FollowState, UnfollowUserSuccess>(unfollowUser),
  new TypedReducer<FollowState, UnfollowStoreSuccess>(unfollowStore),
]);

FollowState fetchFollowedUsers(FollowState state, FetchFollowedUsersSuccess action) {
  return state.copyWith(users: Set.from(state.users)..addAll(action.users));
}
FollowState fetchFollowedStores(FollowState state, FetchFollowedStoresSuccess action) {
  return state.copyWith(stores: Set.from(state.stores)..addAll(action.stores));
}

FollowState followUser(FollowState state, FollowUserSuccess action) {
  return state.copyWith(users: Set.from(state.users)..add(action.userId));
}

FollowState followStore(FollowState state, FollowStoreSuccess action) {
  return state.copyWith(stores: Set.from(state.stores)..add(action.storeId));
}

FollowState unfollowUser(FollowState state, UnfollowUserSuccess action) {
  return state.copyWith(users: Set.from(state.users)..remove(action.userId));
}

FollowState unfollowStore(FollowState state, UnfollowStoreSuccess action) {
  return state.copyWith(stores: Set.from(state.stores)..remove(action.storeId));
}
