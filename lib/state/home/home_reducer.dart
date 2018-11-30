import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/home/home_actions.dart';
import 'package:crust/state/home/home_state.dart';
import 'package:redux/redux.dart';

Reducer<HomeState> homeReducer = combineReducers([
  new TypedReducer<HomeState, FetchStoresSuccess>(fetchStoresSuccess),
  new TypedReducer<HomeState, FetchPostsByStoreIdSuccess>(fetchPostsByStoreIdSuccess),
]);

HomeState fetchStoresSuccess(HomeState state, FetchStoresSuccess action) {
  return state.copyWith(stores: Map.fromEntries(action.stores.map((s) => MapEntry<int, MyStore.Store>(s.id, s))));
}

HomeState fetchPostsByStoreIdSuccess(HomeState state, FetchPostsByStoreIdSuccess action) {
  var newStores = Map<int, MyStore.Store>.from(state.stores);
  newStores[action.storeId] = newStores[action.storeId].copyWith(posts: action.posts);
  return state.copyWith(stores: newStores);
}
