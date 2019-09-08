import 'package:crust/models/search.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_state.dart';
import 'package:redux/redux.dart';

Reducer<MeState> meReducer = combineReducers([
  new TypedReducer<MeState, LoginSuccess>(loginSuccess),
  new TypedReducer<MeState, Logout>(logout),
  new TypedReducer<MeState, FetchMyPostsSuccess>(fetchMyPosts),
  new TypedReducer<MeState, AddSearchHistoryItem>(addSearchHistoryItem),
  new TypedReducer<MeState, SetMyTaglineSuccess>(setMyTagline),
  new TypedReducer<MeState, DeleteMyTaglineSuccess>(deleteMyTagline),
  new TypedReducer<MeState, SetMyProfilePicture>(setMyProfilePicture),
  new TypedReducer<MeState, SetMyDisplayName>(setMyDisplayName),
  new TypedReducer<MeState, SetMyUsername>(setMyUsername),
  new TypedReducer<MeState, SetMyAddress>(setMyAddress),
]);

MeState loginSuccess(MeState state, LoginSuccess action) {
  return MeState.initialState().copyWith(user: action.user);
}

MeState logout(MeState state, Logout action) {
  return MeState.initialState();
}

MeState fetchMyPosts(MeState state, FetchMyPostsSuccess action) {
  return state.copyWith(user: state.user.copyWith(posts: action.posts));
}

MeState addSearchHistoryItem(MeState state, AddSearchHistoryItem action) {
  List<SearchHistoryItem> history = state.searchHistory;
  var item = action.item;
  if (item.type == SearchHistoryItemType.cuisine) {
    history.removeWhere((i) => i.cuisineName == item.cuisineName);
  } else {
    history.removeWhere((i) => i.store != null && i.store.name == item.store.name);
  }
  history.insert(0, action.item);
  if (history.length > 15) history = history.sublist(0, 15);
  return state.copyWith(searchHistory: history);
}

MeState setMyTagline(MeState state, SetMyTaglineSuccess action) {
  return state.copyWith(user: state.user.setTagline(action.tagline));
}

MeState deleteMyTagline(MeState state, DeleteMyTaglineSuccess action) {
  return state.copyWith(user: state.user.setTagline(null));
}

MeState setMyProfilePicture(MeState state, SetMyProfilePicture action) {
  return state.copyWith(user: state.user.copyWith(profilePicture: action.picture));
}

MeState setMyDisplayName(MeState state, SetMyDisplayName action) {
  return state.copyWith(user: state.user.copyWith(displayName: action.name));
}

MeState setMyUsername(MeState state, SetMyUsername action) {
  return state.copyWith(user: state.user.copyWith(username: action.name));
}

MeState setMyAddress(MeState state, SetMyAddress action) {
  return state.copyWith(address: action.address);
}
