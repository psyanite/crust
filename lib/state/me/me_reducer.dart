import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_state.dart';
import 'package:redux/redux.dart';

Reducer<MeState> meReducer = combineReducers([
  new TypedReducer<MeState, LoginSuccess>(loginSuccess),
  new TypedReducer<MeState, Logout>(logout),
  new TypedReducer<MeState, FetchMyPostsSuccess>(fetchMyPosts),
  new TypedReducer<MeState, FavoriteRewardSuccess>(favoriteReward),
  new TypedReducer<MeState, UnfavoriteRewardSuccess>(unfavoriteReward),
  new TypedReducer<MeState, FavoriteStoreSuccess>(favoriteStore),
  new TypedReducer<MeState, UnfavoriteStoreSuccess>(unfavoriteStore),
  new TypedReducer<MeState, FetchFavoritesSuccess>(fetchFavorites),
  new TypedReducer<MeState, FetchUserRewardSuccess>(fetchUserReward),
]);

MeState loginSuccess(MeState state, LoginSuccess action) {
  return MeState().copyWith(user: action.user);
}

MeState logout(MeState state, Logout action) {
  return MeState();
}

MeState fetchMyPosts(MeState state, FetchMyPostsSuccess action) {
  return state.copyWith(user: state.user.copyWith(posts: action.posts));
}

MeState favoriteReward(MeState state, FavoriteRewardSuccess action) {
  return state.copyWith(favoriteRewards: action.rewards);
}

MeState unfavoriteReward(MeState state, UnfavoriteRewardSuccess action) {
  return state.copyWith(favoriteRewards: action.rewards);
}

MeState favoriteStore(MeState state, FavoriteStoreSuccess action) {
  return state.copyWith(favoriteStores: action.stores);
}

MeState unfavoriteStore(MeState state, UnfavoriteStoreSuccess action) {
  return state.copyWith(favoriteStores: action.stores);
}

MeState fetchFavorites(MeState state, FetchFavoritesSuccess action) {
  return state.copyWith(favoriteRewards: action.favoriteRewards, favoriteStores: action.favoriteStores);
}

MeState fetchUserReward(MeState state, FetchUserRewardSuccess action) {
  return state.copyWith(userReward: action.userReward);
}
