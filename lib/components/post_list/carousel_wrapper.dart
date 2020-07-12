import 'package:crust/components/common/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CarouselWrapper extends StatelessWidget {
  final int postId;
  final Widget child;

  CarouselWrapper({Key key, this.postId, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) {
        return _Presenter(
          onFavorite: () {
            if (props.isLoggedIn) {
              props.favoriteComment(postId);
            } else {
              loginSnack(context, 'Login now to favourite posts');
            }
          },
          onUnfavorite: () {
            props.unfavoriteComment(postId);
          },
          isFavorited: props.favoritePosts.contains(postId),
          child: child,
          isLoggedIn: props.isLoggedIn,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final Function onFavorite;
  final Function onUnfavorite;
  final bool isFavorited;
  final Widget child;
  final bool isLoggedIn;

  _Presenter({Key key, this.onFavorite, this.onUnfavorite, this.isFavorited, this.child, this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) return child;
    return GestureDetector(
      onDoubleTap: () {
        isFavorited ? onUnfavorite() : onFavorite();
      },
      child: child,
    );
  }
}

class _Props {
  final Set<int> favoritePosts;
  final Function favoritePost;
  final Function unfavoritePost;
  final bool isLoggedIn;

  _Props({
    this.favoritePosts,
    this.favoritePost,
    this.unfavoritePost,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      favoritePosts: store.state.favorite.posts,
      favoritePost: (postId) => store.dispatch(FavoritePost(postId)),
      unfavoritePost: (postId) => store.dispatch(UnfavoritePost(postId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
