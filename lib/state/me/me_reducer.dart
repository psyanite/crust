import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_state.dart';
import 'package:redux/redux.dart';

Reducer<MeState> meReducer = combineReducers([
  new TypedReducer<MeState, LoginSuccess>(loginSuccess),
  new TypedReducer<MeState, Logout>(logout),
  new TypedReducer<MeState, FetchMyPostsSuccess>(fetchMyPosts),
  new TypedReducer<MeState, FavoriteRewardSuccess>(favoriteReward),
  new TypedReducer<MeState, UnfavoriteRewardSuccess>(unfavoriteReward),
  new TypedReducer<MeState, FetchFavoritesSuccess>(fetchFavorites),
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

MeState fetchFavorites(MeState state, FetchFavoritesSuccess action) {
  return state.copyWith(favoriteRewards: action.favoriteRewards, favoriteStores: action.favoriteStores);
}
