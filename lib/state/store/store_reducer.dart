import 'package:crust/state/store/store_actions.dart';
import 'package:crust/state/store/store_state.dart';
import 'package:redux/redux.dart';

Reducer<StoreState> storeReducer = combineReducers([
  new TypedReducer<StoreState, FetchStoreSuccess>(fetchStoreSuccess),
  new TypedReducer<StoreState, FetchStoresSuccess>(fetchStoresSuccess),
  new TypedReducer<StoreState, FetchRewardsByStoreIdSuccess>(fetchRewardsByStoreIdSuccess),
  new TypedReducer<StoreState, FetchTopStoresSuccess>(fetchTopStoresSuccess),
  new TypedReducer<StoreState, FetchFamousStoresSuccess>(fetchFamousStoresSuccess),
  new TypedReducer<StoreState, FetchCurateSuccess>(fetchCurateSuccess),
]);

StoreState fetchStoreSuccess(StoreState state, FetchStoreSuccess action) {
  return state.addStore(action.store);
}

StoreState fetchStoresSuccess(StoreState state, FetchStoresSuccess action) {
  return state.addStores(action.stores);
}

StoreState fetchRewardsByStoreIdSuccess(StoreState state, FetchRewardsByStoreIdSuccess action) {
  return state.addStoreRewards(action.storeId, action.rewards);
}

StoreState fetchTopStoresSuccess(StoreState state, FetchTopStoresSuccess action) {
  return state.setTopStores(action.stores);
}

StoreState fetchFamousStoresSuccess(StoreState state, FetchFamousStoresSuccess action) {
  return state.setFamousStores(action.stores);
}

StoreState fetchCurateSuccess(StoreState state, FetchCurateSuccess action) {
  return state.addCurate(action.curate);
}
