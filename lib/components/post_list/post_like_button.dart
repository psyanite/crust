import 'package:crust/presentation/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class PostLikeButton extends StatelessWidget {
  final int postId;
  final double padding;
  final double size;

  PostLikeButton({Key key, this.postId, this.padding, this.size});

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
            padding: padding,
            size: size));
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
  final double size;
  final double padding;

  _Presenter({Key key, this.onFavorite, this.onUnfavorite, this.isFavorited, padding, size})
      : padding = padding ?? 0.0,
        size = size ?? 30.0,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          isFavorited ? onUnfavorite() : onFavorite();
        },
        child: SvgPicture.asset(
          isFavorited ? 'assets/svgs/like-filled.svg' : 'assets/svgs/like-outlined.svg',
        ),
      ),
    );
  }
}
