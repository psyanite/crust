import 'package:crust/presentation/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class PostLikeButton extends StatefulWidget {
  final int postId;

  PostLikeButton({Key key, this.postId}) : super(key: key);

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
              snack(context, 'Please login to favourite posts');
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
              padding: 2.0 - paddingCtrl.value);
        });
  }
}

class _Presenter extends StatelessWidget {
  final Function onTap;
  final bool isFavorited;
  final double padding;

  _Presenter({Key key, this.onTap, this.isFavorited, this.padding}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: padding, bottom: padding),
      width: 34.0,
      height: 34.0,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: onTap,
        child: SvgPicture.asset(
          isFavorited ? 'assets/svgs/like-filled.svg' : 'assets/svgs/like-outlined.svg',
          alignment: Alignment.centerRight,
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
    var favoritePosts = store.state.me.favoritePosts ?? Set<int>();
    return _Props(
      isFavorited: favoritePosts.contains(postId),
      favoritePost: (postId) => store.dispatch(FavoritePostRequest(postId)),
      unfavoritePost: (postId) => store.dispatch(UnfavoritePostRequest(postId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
