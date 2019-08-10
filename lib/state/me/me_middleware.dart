import 'package:crust/models/post.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createMeMiddleware([MeService meService = const MeService(), PostService postService = const PostService()]) {
  final addUser = _addUser(meService);
  final fetchMyPosts = _fetchMyPosts(postService);
  final favoriteReward = _favoriteReward(meService);
  final unfavoriteReward = _unfavoriteReward(meService);
  final favoriteStore = _favoriteStore(meService);
  final unfavoriteStore = _unfavoriteStore(meService);
  final favoritePost = _favoritePost(meService);
  final unfavoritePost = _unfavoritePost(meService);
  final fetchFavorites = _fetchFavorites(meService);
  final setTagline = _setTagline(meService);
  final deleteTagline = _deleteTagline(meService);

  return [
    TypedMiddleware<AppState, AddUser>(addUser),
    TypedMiddleware<AppState, FetchMyPosts>(fetchMyPosts),
    TypedMiddleware<AppState, FavoriteReward>(favoriteReward),
    TypedMiddleware<AppState, UnfavoriteReward>(unfavoriteReward),
    TypedMiddleware<AppState, FavoriteStore>(favoriteStore),
    TypedMiddleware<AppState, UnfavoriteStore>(unfavoriteStore),
    TypedMiddleware<AppState, FavoritePost>(favoritePost),
    TypedMiddleware<AppState, UnfavoritePost>(unfavoritePost),
    TypedMiddleware<AppState, FetchFavorites>(fetchFavorites),
    TypedMiddleware<AppState, SetMyTagline>(setTagline),
    TypedMiddleware<AppState, DeleteMyTagline>(deleteTagline),
  ];
}

Middleware<AppState> _addUser(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.addUser(action.me).then((userId) {
      store.dispatch(LoginSuccess(action.me.copyWith(id: userId)));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _fetchMyPosts(PostService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.fetchMyPosts(action.userId).then(
      (posts) {
        store.dispatch(FetchMyPostsSuccess(posts));
      },
    ).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoriteReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoriteRewardSuccess(action.rewardId));
    service.favoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(FetchFavoritesSuccess(favoriteRewards: rewards));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoriteReward(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoriteRewardSuccess(action.rewardId));
    service.unfavoriteReward(userId: store.state.me.user.id, rewardId: action.rewardId).then((rewards) {
      store.dispatch(FetchFavoritesSuccess(favoriteRewards: rewards));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoriteStore(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoriteStoreSuccess(action.storeId));
    service.favoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(FetchFavoritesSuccess(favoriteStores: stores));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoriteStore(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoriteStoreSuccess(action.storeId));
    service.unfavoriteStore(userId: store.state.me.user.id, storeId: action.storeId).then((stores) {
      store.dispatch(FetchFavoritesSuccess(favoriteStores: stores));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _favoritePost(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(FavoritePostSuccess(action.postId));
    service.favoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(FetchFavoritesSuccess(favoritePosts: posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _unfavoritePost(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    store.dispatch(UnfavoritePostSuccess(action.postId));
    service.unfavoritePost(userId: store.state.me.user.id, postId: action.postId).then((posts) {
      store.dispatch(FetchFavoritesSuccess(favoritePosts: posts));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _fetchFavorites(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    if (store.state.me.user != null) {
      service.fetchFavorites(store.state.me.user.id).then((map) {
        List<Reward> rewards = map['rewards'];
        List<MyStore.Store> stores = map['stores'];
        List<Post> posts = map['posts'];
        store.dispatch(FetchFavoritesSuccess(
            favoriteRewards: rewards.map((r) => r.id).toSet(),
            favoriteStores: stores.map((s) => s.id).toSet(),
            favoritePosts: posts.map((p) => p.id).toSet()));
        if (action.updateStore) {
          store.dispatch(FetchRewardsSuccess(rewards));
          store.dispatch(FetchStoresSuccess(stores));
        }
      }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    }
    next(action);
  };
}

Middleware<AppState> _setTagline(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.setTagline(userId: store.state.me.user.id, tagline: action.tagline).then((tagline) {
      store.dispatch(SetMyTaglineSuccess(tagline));
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}

Middleware<AppState> _deleteTagline(MeService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.deleteTagline(store.state.me.user.id).then((result) {
      if (result == true) {
        store.dispatch(DeleteMyTaglineSuccess());
      } else {
        store.dispatch(RequestFailure('Delete tagline request result was false'));
      }
    }).catchError((e) => store.dispatch(RequestFailure(e.toString())));
    next(action);
  };
}
