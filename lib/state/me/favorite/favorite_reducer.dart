import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:crust/state/me/favorite/favorite_state.dart';
import 'package:redux/redux.dart';

Reducer<FavoriteState> favoriteReducer = combineReducers([
  new TypedReducer<FavoriteState, FavoriteRewardSuccess>(favoriteReward),
  new TypedReducer<FavoriteState, UnfavoriteRewardSuccess>(unfavoriteReward),
  new TypedReducer<FavoriteState, FavoriteStoreSuccess>(favoriteStore),
  new TypedReducer<FavoriteState, UnfavoriteStoreSuccess>(unfavoriteStore),
  new TypedReducer<FavoriteState, FavoritePostSuccess>(favoritePost),
  new TypedReducer<FavoriteState, UnfavoritePostSuccess>(unfavoritePost),
  new TypedReducer<FavoriteState, FetchFavoriteRewardsSuccess>(fetchFavoriteRewards),
  new TypedReducer<FavoriteState, FetchFavoritesSuccess>(fetchFavorites),
]);

FavoriteState favoriteReward(FavoriteState state, FavoriteRewardSuccess action) {
  return state.copyWith(rewards: Set.from(state.rewards)..add(action.rewardId));
}

FavoriteState unfavoriteReward(FavoriteState state, UnfavoriteRewardSuccess action) {
  return state.copyWith(rewards: Set.from(state.rewards)..remove(action.rewardId));
}

FavoriteState favoriteStore(FavoriteState state, FavoriteStoreSuccess action) {
  return state.copyWith(stores: Set.from(state.stores)..add(action.storeId));
}

FavoriteState unfavoriteStore(FavoriteState state, UnfavoriteStoreSuccess action) {
  return state.copyWith(stores: Set.from(state.stores)..remove(action.storeId));
}

FavoriteState favoritePost(FavoriteState state, FavoritePostSuccess action) {
  return state.copyWith(posts: Set.from(state.posts)..add(action.postId));
}

FavoriteState unfavoritePost(FavoriteState state, UnfavoritePostSuccess action) {
  return state.copyWith(posts: Set.from(state.posts)..remove(action.postId));
}

FavoriteState fetchFavoriteRewards(FavoriteState state, FetchFavoriteRewardsSuccess action) {
  return state.copyWith(rewards: action.favoriteRewards);
}

FavoriteState fetchFavorites(FavoriteState state, FetchFavoritesSuccess action) {
  return state.copyWith(stores: action.favoriteStores, posts: action.favoritePosts);
}
