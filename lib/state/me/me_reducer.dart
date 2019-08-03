import 'package:crust/models/search.dart';
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
  new TypedReducer<MeState, FavoritePostSuccess>(favoritePost),
  new TypedReducer<MeState, UnfavoritePostSuccess>(unfavoritePost),
  new TypedReducer<MeState, FetchFavoritesSuccess>(fetchFavorites),
  new TypedReducer<MeState, AddSearchHistoryItem>(addSearchHistoryItem),
  new TypedReducer<MeState, SetMyLocation>(setMyLocation),
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
  return state.copyWith(favoriteRewards: Set.from(state.favoriteRewards)..add(action.rewardId));
}

MeState unfavoriteReward(MeState state, UnfavoriteRewardSuccess action) {
  return state.copyWith(favoriteRewards: Set.from(state.favoriteRewards)..remove(action.rewardId));
}

MeState favoriteStore(MeState state, FavoriteStoreSuccess action) {
  return state.copyWith(favoriteStores: Set.from(state.favoriteStores)..add(action.storeId));
}

MeState unfavoriteStore(MeState state, UnfavoriteStoreSuccess action) {
  return state.copyWith(favoriteStores: Set.from(state.favoriteStores)..remove(action.storeId));
}

MeState favoritePost(MeState state, FavoritePostSuccess action) {
  return state.copyWith(favoritePosts: Set.from(state.favoritePosts)..add(action.postId));
}

MeState unfavoritePost(MeState state, UnfavoritePostSuccess action) {
  return state.copyWith(favoritePosts: Set.from(state.favoritePosts)..remove(action.postId));
}

MeState fetchFavorites(MeState state, FetchFavoritesSuccess action) {
  return state.copyWith(
      favoriteRewards: action.favoriteRewards, favoriteStores: action.favoriteStores, favoritePosts: action.favoritePosts);
}

MeState addSearchHistoryItem(MeState state, AddSearchHistoryItem action) {
  List<SearchHistoryItem> history = state.searchHistory;
  var item = action.item;
  if (item.type == SearchHistoryItemType.cuisine) {
    history.removeWhere((i) => i.cuisineName == item.cuisineName);
  } else {
    history.removeWhere((i) => i.store != null && i.store.name == item.store.name);
  }
  history.insert(0, action.item);
  if (history.length > 15) history = history.sublist(0, 15);
  return state.copyWith(searchHistory: history);
}

MeState setMyLocation(MeState state, SetMyLocation action) {
  return state.copyWith(location: action.location);
}
