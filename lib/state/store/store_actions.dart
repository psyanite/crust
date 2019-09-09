import 'package:crust/models/curate.dart';
import 'package:crust/models/store.dart';

class FetchStoreById {
  final int storeId;

  FetchStoreById(this.storeId);
}

class FetchStoreSuccess {
  final Store store;

  FetchStoreSuccess(this.store);
}

class FetchStoresSuccess {
  final List<Store> stores;

  FetchStoresSuccess(this.stores);
}

class FetchTopStores {}

class FetchTopStoresSuccess {
  final List<Store> stores;

  FetchTopStoresSuccess(this.stores);
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

class FetchCurate {
  final Curate curate;

  FetchCurate(this.curate);
}

class FetchCurateSuccess {
  final Curate curate;

  FetchCurateSuccess(this.curate);
}
