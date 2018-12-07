import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/store/store_actions.dart';
import 'package:crust/state/store/store_state.dart';
import 'package:redux/redux.dart';

Reducer<StoreState> storeReducer = combineReducers([
  new TypedReducer<StoreState, FetchStoresSuccess>(fetchStoresSuccess),
  new TypedReducer<StoreState, FetchPostsByStoreIdSuccess>(fetchPostsByStoreIdSuccess),
]);

StoreState fetchStoresSuccess(StoreState state, FetchStoresSuccess action) {
  return state.copyWith(stores: action.stores);
}

StoreState fetchPostsByStoreIdSuccess(StoreState state, FetchPostsByStoreIdSuccess action) {
  return state.copyWith(stores: List<MyStore.Store>.from([state.stores[action.storeId].copyWith(posts: action.posts)]));
}
