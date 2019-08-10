import 'package:crust/models/post.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/user.dart';

class AddUser {
  final User user;

  AddUser(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class FetchMyPosts {
  final int userId;

  FetchMyPosts(this.userId);
}

class FetchMyPostsSuccess {
  final List<Post> posts;

  FetchMyPostsSuccess(this.posts);
}

class LogoutSuccess {}

class Logout {}

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

class FetchFavorites {
  final bool updateStore;

  FetchFavorites({this.updateStore: false});
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

class SetMyProfilePicture {
  final String picture;

  SetMyProfilePicture(this.picture);
}

class SetMyDisplayName {
  final String name;

  SetMyDisplayName(this.name);
}

class SetMyUsername {
  final String name;

  SetMyUsername(this.name);
}
