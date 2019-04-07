import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/carousel.dart';
import 'package:crust/components/post_list/post_like_button.dart';
import 'package:crust/components/screens/profile_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/post.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CarouselWrapper extends StatelessWidget {
  final int postId;
  final Widget child;

  CarouselWrapper({Key key, this.postId, this.child});

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) => _Presenter(
        onFavorite: () {
          if (props.isLoggedIn) {
            props.favoritePost(postId);
          } else {
            snack(context, 'Please login to favourite posts');
          }
        },
        onUnfavorite: () {
          props.unfavoritePost(postId);
        },
        isFavorited: props.favoritePosts.contains(postId),
      child: child,
      isLoggedIn: props.isLoggedIn));
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
      favoritePosts: store.state.me.favoritePosts ?? Set<int>(),
      favoritePost: (postId) => store.dispatch(FavoritePostRequest(postId)),
      unfavoritePost: (postId) => store.dispatch(UnfavoritePostRequest(postId)),
      isLoggedIn: store.state.me.user != null,
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
      child: child
    );
  }
}


enum PostListType { forStore, forProfile }
