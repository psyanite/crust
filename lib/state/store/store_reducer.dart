import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/store/store_actions.dart';
import 'package:crust/state/store/store_state.dart';
import 'package:redux/redux.dart';

Reducer<StoreState> storeReducer = combineReducers([
  new TypedReducer<StoreState, FetchStoresSuccess>(fetchStoresSuccess),
  new TypedReducer<StoreState, FetchTopStoresSuccess>(fetchTopStoresSuccess),
  new TypedReducer<StoreState, FetchStoreSuccess>(fetchStoreSuccess),
  new TypedReducer<StoreState, FetchPostsByStoreIdSuccess>(fetchPostsByStoreIdSuccess),
]);

StoreState fetchStoresSuccess(StoreState state, FetchStoresSuccess action) {
  return state.addStores(action.stores);
}

StoreState fetchTopStoresSuccess(StoreState state, FetchTopStoresSuccess action) {
  return state.addTopStores(action.stores);
}

StoreState fetchStoreSuccess(StoreState state, FetchStoreSuccess action) {
  return state.addStore(action.store);
}

StoreState fetchPostsByStoreIdSuccess(StoreState state, FetchPostsByStoreIdSuccess action) {
  return state.addStores(List<MyStore.Store>.from([state.stores[action.storeId].copyWith(posts: action.posts)]));
}
