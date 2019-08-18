import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createFeedMiddleware([FeedService feedService = const FeedService()]) {
  final fetchDefaultFeed = _fetchDefaultFeed(feedService);
  final fetchFeed = _fetchFeed(feedService);

  return [
    TypedMiddleware<AppState, FetchDefaultFeed>(fetchDefaultFeed),
    TypedMiddleware<AppState, FetchFeed>(fetchFeed),
  ];
}

Middleware<AppState> _fetchDefaultFeed(FeedService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchDefaultFeed().then((posts) {
      store.dispatch(FetchFeedSuccess(posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _fetchFeed(FeedService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchFeed(action.userId).then((posts) {
      store.dispatch(FetchFeedSuccess(posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}
