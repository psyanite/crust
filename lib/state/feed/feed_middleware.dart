import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/feed/feed_actions.dart';
import 'package:crust/state/feed/feed_service.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createFeedMiddleware([FeedService feedService = const FeedService()]) {
  final fetchFeed = _fetchFeed(feedService);

  return [
    TypedMiddleware<AppState, FetchFeed>(fetchFeed),
  ];
}

Middleware<AppState> _fetchFeed(FeedService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var me = store.state.me.user;

    var promise = me != null ? service.fetchFeed(userId: me.id, limit: 7, offset: 0) : service.fetchDefaultFeed(limit: 7, offset: 0);

    promise.then((posts) {
      store.dispatch(FetchFeedSuccess(posts));
    }).catchError((e) => store.dispatch(RequestFailure("fetchFeed ${e.toString()}")));

    next(action);
  };
}
