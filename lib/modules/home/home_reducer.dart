import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/home_state.dart';
import 'package:redux/redux.dart';

Reducer<HomeState> homeReducer = combineReducers([
  new TypedReducer<HomeState, FetchStoresRequest>(fetchStores),
  new TypedReducer<HomeState, FetchStoresSuccess>(fetchStoresSuccess),
  new TypedReducer<HomeState, FetchStoresFailure>(fetchStoresFailure),
]);

HomeState fetchStores(HomeState state, FetchStoresRequest action) {
  return state;
}

HomeState fetchStoresSuccess(HomeState state, FetchStoresSuccess action) {
  return state.copyWith(stores: action.stores);
}

HomeState fetchStoresFailure(HomeState state, FetchStoresFailure action) {
  return state.copyWith(error: action.error.toString());
}
