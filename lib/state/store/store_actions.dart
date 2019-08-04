import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart';

class FetchStoreByIdRequest {
  final int storeId;

  FetchStoreByIdRequest(this.storeId);
}

class FetchStoreSuccess {
  final Store store;

  FetchStoreSuccess(this.store);
}

class FetchStoresRequest {}

class FetchStoresSuccess {
  final List<Store> stores;

  FetchStoresSuccess(this.stores);
}

class FetchTopStoresRequest {}

class FetchTopStoresSuccess {
  final List<Store> stores;

  FetchTopStoresSuccess(this.stores);
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
