class FavoriteReward {
  final int rewardId;

  FavoriteReward(this.rewardId);
}

class FavoriteRewardSuccess {
  final int rewardId;

  FavoriteRewardSuccess(this.rewardId);
}

class UnfavoriteReward {
  final int rewardId;

  UnfavoriteReward(this.rewardId);
}

class UnfavoriteRewardSuccess {
  final int rewardId;

  UnfavoriteRewardSuccess(this.rewardId);
}

class FavoriteStore {
  final int storeId;

  FavoriteStore(this.storeId);
}

class FavoriteStoreSuccess {
  final int storeId;

  FavoriteStoreSuccess(this.storeId);
}

class UnfavoriteStore {
  final int storeId;

  UnfavoriteStore(this.storeId);
}

class UnfavoriteStoreSuccess {
  final int storeId;

  UnfavoriteStoreSuccess(this.storeId);
}

class FavoritePost {
  final int postId;

  FavoritePost(this.postId);
}

class FavoritePostSuccess {
  final int postId;

  FavoritePostSuccess(this.postId);
}

class UnfavoritePost {
  final int postId;

  UnfavoritePost(this.postId);
}

class UnfavoritePostSuccess {
  final int postId;

  UnfavoritePostSuccess(this.postId);
}

class FetchFavorites {}

class FetchFavoriteRewardsSuccess {
  final Set<int> favoriteRewards;

  FetchFavoriteRewardsSuccess({this.favoriteRewards});
}

class FetchFavoritesSuccess {
  final Set<int> favoriteStores;
  final Set<int> favoritePosts;

  FetchFavoritesSuccess({this.favoriteStores, this.favoritePosts});
}
