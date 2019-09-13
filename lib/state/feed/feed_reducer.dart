import 'dart:collection';

import 'package:crust/models/post.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_state.dart';
import 'package:redux/redux.dart';

Reducer<FeedState> feedReducer = combineReducers([
  new TypedReducer<FeedState, FetchFeedSuccess>(fetchFeedSuccess),
  new TypedReducer<FeedState, RemoveFeedPost>(removePost),
  new TypedReducer<FeedState, ClearFeed>(clearAll),
]);

FeedState fetchFeedSuccess(FeedState state, FetchFeedSuccess action) {
  return state.addPosts(action.posts);
}

FeedState removePost(FeedState state, RemoveFeedPost action) {
  return state.removePost(action.postId);
}

FeedState clearAll(FeedState state, ClearFeed action) {
  return state.copyWith(posts: LinkedHashMap<int, Post>());
}
