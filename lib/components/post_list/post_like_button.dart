import 'package:crust/components/common/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class PostLikeButton extends StatefulWidget {
  final int postId;
  final double size;

  PostLikeButton({Key key, this.postId, this.size = 34.0}) : super(key: key);

  @override
  _PostLikeButtonState createState() => _PostLikeButtonState(postId: postId);
}

class _PostLikeButtonState extends State<PostLikeButton> with TickerProviderStateMixin {
  final int postId;
  AnimationController paddingCtrl;

  _PostLikeButtonState({this.postId});

  @override
  initState() {
    super.initState();
    paddingCtrl = AnimationController(upperBound: 2.0, vsync: this, duration: Duration(milliseconds: 300));
    paddingCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        paddingCtrl.reverse();
      }
    });
    paddingCtrl.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => _Props.fromStore(store, postId),
        builder: (context, props) {
          var onFavorite = () {
            if (props.isLoggedIn) {
              props.favoritePost(postId);
            } else {
              snack(context, 'Login now to favourite posts');
            }
          };
          var onUnfavorite =  () {
            props.unfavoritePost(postId);
          };
          var onTap = () {
            paddingCtrl.forward(from: 0.0);
            props.isFavorited ? onUnfavorite() : onFavorite();
          };
          return _Presenter(
              onTap: onTap,
              isFavorited: props.isFavorited,
              size: widget.size,
              padding: 2.0 - paddingCtrl.value);
        });
  }
}

class _Presenter extends StatelessWidget {
  final Function onTap;
  final bool isFavorited;
  final double size;
  final double padding;

  _Presenter({Key key, this.onTap, this.isFavorited, this.size, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      width: size,
      height: size,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: SvgPicture.asset(
          isFavorited ? 'assets/svgs/like-filled.svg' : 'assets/svgs/like-outlined.svg',
          alignment: Alignment.center,
        ),
      ),
    );
  }
}

class _Props {
  final bool isFavorited;
  final Function favoritePost;
  final Function unfavoritePost;
  final bool isLoggedIn;

  _Props({
    this.isFavorited,
    this.favoritePost,
    this.unfavoritePost,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store, int postId) {
    var favoritePosts = store.state.favorite.posts;
    return _Props(
      isFavorited: favoritePosts.contains(postId),
      favoritePost: (postId) => store.dispatch(FavoritePost(postId)),
      unfavoritePost: (postId) => store.dispatch(UnfavoritePost(postId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
