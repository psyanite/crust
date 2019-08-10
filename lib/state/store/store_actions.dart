import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart';

class FetchStoreById {
  final int storeId;

  FetchStoreById(this.storeId);
}

class FetchStoreSuccess {
  final Store store;

  FetchStoreSuccess(this.store);
}

class FetchStores {}

class FetchStoresSuccess {
  final List<Store> stores;

  FetchStoresSuccess(this.stores);
}

class FetchTopStores {}

class FetchTopStoresSuccess {
  final List<Store> stores;

  FetchTopStoresSuccess(this.stores);
}

class FetchPostsByStoreId {
  final int storeId;

  FetchPostsByStoreId(this.storeId);
}

class FetchPostsByStoreIdSuccess {
  final int storeId;
  final List<Post> posts;

  FetchPostsByStoreIdSuccess(this.storeId, this.posts);
}

class FetchRewardsByStoreId {
  final int storeId;

  FetchRewardsByStoreId(this.storeId);
}

class FetchRewardsByStoreIdSuccess {
  final int storeId;
  final List<int> rewards;

  FetchRewardsByStoreIdSuccess(this.storeId, this.rewards);
}
