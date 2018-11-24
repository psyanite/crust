import 'package:crust/models/Post.dart';
import 'package:crust/models/store.dart';

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
