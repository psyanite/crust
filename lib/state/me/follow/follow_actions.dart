

class FetchFollows {}

class FetchFollowedUsersSuccess {
  final List<int> users;

  FetchFollowedUsersSuccess(this.users);
}

class FetchFollowedStoresSuccess {
  final List<int> stores;

  FetchFollowedStoresSuccess(this.stores);
}

class FollowStore {
  final int storeId;

  FollowStore(this.storeId);
}

class FollowStoreSuccess {
  final int storeId;

  FollowStoreSuccess(this.storeId);
}

class UnfollowStore {
  final int storeId;

  UnfollowStore(this.storeId);
}

class UnfollowStoreSuccess {
  final int storeId;

  UnfollowStoreSuccess(this.storeId);
}

class FollowUser {
  final int userId;

  FollowUser(this.userId);
}

class FollowUserSuccess {
  final int userId;

  FollowUserSuccess(this.userId);
}

class UnfollowUser {
  final int userId;

  UnfollowUser(this.userId);
}

class UnfollowUserSuccess {
  final int userId;

  UnfollowUserSuccess(this.userId);
}
