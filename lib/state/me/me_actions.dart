import 'package:crust/models/post.dart';
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
  final Set<int> rewards;

  FavoriteRewardSuccess(this.rewards);
}

class UnfavoriteRewardRequest {
  final int rewardId;

  UnfavoriteRewardRequest(this.rewardId);
}

class UnfavoriteRewardSuccess {
  final Set<int> rewards;

  UnfavoriteRewardSuccess(this.rewards);
}

class FetchFavoritesRequest {}

class FetchFavoritesSuccess {
  final Set<int> favoriteRewards;
  final Set<int> favoriteStores;

  FetchFavoritesSuccess({this.favoriteRewards, this.favoriteStores});
}
