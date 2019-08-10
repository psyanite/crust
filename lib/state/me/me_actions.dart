import 'package:crust/models/post.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/user.dart';

class AddUserRequest {
  final User user;

  AddUserRequest(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class FetchMyPostsRequest {
  final int userId;

  FetchMyPostsRequest(this.userId);
}

class FetchMyPostsSuccess {
  final List<Post> posts;

  FetchMyPostsSuccess(this.posts);
}

class LogoutSuccess {}

class Logout {}

class FavoriteRewardRequest {
  final int rewardId;

  FavoriteRewardRequest(this.rewardId);
}

class FavoriteRewardSuccess {
  final int rewardId;

  FavoriteRewardSuccess(this.rewardId);
}

class UnfavoriteRewardRequest {
  final int rewardId;

  UnfavoriteRewardRequest(this.rewardId);
}

class UnfavoriteRewardSuccess {
  final int rewardId;

  UnfavoriteRewardSuccess(this.rewardId);
}

class FavoriteStoreRequest {
  final int storeId;

  FavoriteStoreRequest(this.storeId);
}

class FavoriteStoreSuccess {
  final int storeId;

  FavoriteStoreSuccess(this.storeId);
}

class UnfavoriteStoreRequest {
  final int storeId;

  UnfavoriteStoreRequest(this.storeId);
}

class UnfavoriteStoreSuccess {
  final int storeId;

  UnfavoriteStoreSuccess(this.storeId);
}

class FavoritePostRequest {
  final int postId;

  FavoritePostRequest(this.postId);
}

class FavoritePostSuccess {
  final int postId;

  FavoritePostSuccess(this.postId);
}

class UnfavoritePostRequest {
  final int postId;

  UnfavoritePostRequest(this.postId);
}

class UnfavoritePostSuccess {
  final int postId;

  UnfavoritePostSuccess(this.postId);
}

class FetchFavoritesRequest {
  final bool updateStore;

  FetchFavoritesRequest({this.updateStore: false});
}

class FetchFavoritesSuccess {
  final Set<int> favoriteRewards;
  final Set<int> favoriteStores;
  final Set<int> favoritePosts;

  FetchFavoritesSuccess({this.favoriteRewards, this.favoriteStores, this.favoritePosts});
}

class AddSearchHistoryItem {
  final SearchHistoryItem item;

  AddSearchHistoryItem(this.item);
}

class SetMyLocation {
  final SearchLocationItem location;

  SetMyLocation(this.location);
}

class SetMyTagline {
  final String tagline;

  SetMyTagline(this.tagline);
}

class SetMyTaglineSuccess {
  final String tagline;

  SetMyTaglineSuccess(this.tagline);
}

class DeleteMyTagline {}

class DeleteMyTaglineSuccess {}
