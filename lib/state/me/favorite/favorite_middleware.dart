import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:crust/state/me/favorite/favorite_service.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createFavoriteMiddleware([FavoriteService favoriteService = const FavoriteService()]) {
  final favoriteReward = _favoriteReward(favoriteService);
  final unfavoriteReward = _unfavoriteReward(favoriteService);
  final favoriteStore = _favoriteStore(favoriteService);
  final unfavoriteStore = _unfavoriteStore(favoriteService);
  final favoritePost = _favoritePost(favoriteService);
  final unfavoritePost = _unfavoritePost(favoriteService);
  final fetchFavorites = _fetchFavorites(favoriteService);

  return [
    TypedMiddleware<AppState, FavoriteReward>(favoriteReward),
    TypedMiddleware<AppState, UnfavoriteReward>(unfavoriteReward),
    TypedMiddleware<AppState, FavoriteStore>(favoriteStore),
    TypedMiddleware<AppState, UnfavoriteStore>(unfavoriteStore),
    TypedMiddleware<AppState, FavoritePost>(favoritePost),
    TypedMiddleware<AppState, UnfavoritePost>(unfavoritePost),
    TypedMiddleware<AppState, FetchFavorites>(fetchFavorites),
  ];
}

Middleware<AppState> _favoriteReward(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoriteRewardSuccess(action.rewardId));
    service.favoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(FetchFavoriteRewardsSuccess(favoriteRewards: rewards));
    }).catchError((e) => store.dispatch(RequestFailure("favoriteReward ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _unfavoriteReward(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoriteRewardSuccess(action.rewardId));
    service.unfavoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(FetchFavoriteRewardsSuccess(favoriteRewards: rewards));
    }).catchError((e) => store.dispatch(RequestFailure("unfavoriteReward ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _favoriteStore(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoriteStoreSuccess(action.storeId));
    service.favoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(FetchFavoritesSuccess(favoriteStores: stores));
    }).catchError((e) => store.dispatch(RequestFailure("favoriteStore ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _unfavoriteStore(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoriteStoreSuccess(action.storeId));
    service.unfavoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(FetchFavoritesSuccess(favoriteStores: stores));
    }).catchError((e) => store.dispatch(RequestFailure("unfavoriteStore ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _favoritePost(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoritePostSuccess(action.postId));
    service.favoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(FetchFavoritesSuccess(favoritePosts: posts));
    }).catchError((e) => store.dispatch(RequestFailure("favoritePost ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _unfavoritePost(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoritePostSuccess(action.postId));
    service.unfavoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(FetchFavoritesSuccess(favoritePosts: posts));
    }).catchError((e) => store.dispatch(RequestFailure("unfavoritePost ${e.toString()}")));
    next(action);
  };
}

Middleware<AppState> _fetchFavorites(FavoriteService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var user = store.state.me.user;
    if (user != null) {
      service.fetchFavorites(user.id).then((map) {
        List<MyStore.Store> stores = map['stores'];
        if (stores.isNotEmpty) store.dispatch(FetchStoresSuccess(stores));
        List<int> postIds = map['postIds'];
        store.dispatch(FetchFavoritesSuccess(
            favoriteStores: stores.map((s) => s.id).toSet(),
            favoritePosts: postIds.toSet()));
      }).catchError((e) => store.dispatch(RequestFailure("fetchFavorites ${e.toString()}")));

      service.fetchFavoriteRewards(user.id).then((rewards) {
        if (rewards.isNotEmpty) {
          store.dispatch(FetchRewardsSuccess(rewards));
          store.dispatch(FetchFavoriteRewardsSuccess(favoriteRewards: rewards.map((r) => r.id).toSet()));
        }
      }).catchError((e) => store.dispatch(RequestFailure("fetchFavoriteRewards ${e.toString()}")));
    }
    next(action);
  };
}
