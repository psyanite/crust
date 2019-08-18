import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_state.dart';
import 'package:redux/redux.dart';

Reducer<FeedState> feedReducer = combineReducers([
  new TypedReducer<FeedState, FetchFeedSuccess>(fetchFeedSuccess),
]);

FeedState fetchFeedSuccess(FeedState state, FetchFeedSuccess action) {
  return state.copyWith(posts: action.posts);
}
