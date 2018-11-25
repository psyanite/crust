import 'package:crust/models/Post.dart';
import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';

class FetchStoresRequest {}

class FetchStoresSuccess {
  final List<Store> stores;

  FetchStoresSuccess(this.stores);
}

class FetchPostsByStoreIdRequest {
  final int storeId;

  FetchPostsByStoreIdRequest(this.storeId);
}

class FetchPostsByStoreIdSuccess {
  final int storeId;
  final List<Post> posts;

  FetchPostsByStoreIdSuccess(this.storeId, this.posts);
}

class FetchUserByUserIdRequest {
  final int userId;

  FetchUserByUserIdRequest(this.userId);
}

class FetchUserByUserIdSuccess {
  final User user;

  FetchUserByUserIdSuccess(this.user);
}
