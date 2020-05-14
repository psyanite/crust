import 'package:crust/models/comment.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:redux/redux.dart';

class CommentLikeButton extends StatefulWidget {
  final Comment comment;

  CommentLikeButton({Key key, this.comment}) : super(key: key);

  @override
  _CommentLikeButtonState createState() => _CommentLikeButtonState();
}

class _CommentLikeButtonState extends State<CommentLikeButton> with TickerProviderStateMixin {
  AnimationController paddingCtrl;

  _CommentLikeButtonState();

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
      converter: (Store<AppState> store) => _Props.fromStore(store, widget.comment),
      builder: (context, props) {
        var isFavorited = widget.comment.likedByUsers.contains(props.myId);
        var onFavorite = () {
          if (props.isLoggedIn) {
            props.favoriteComment(widget.comment);
          } else {
            snack(context, 'Login now to favourite comments');
          }
        };
        var onUnfavorite = () {
          props.unfavoriteComment(widget.comment);
        };
        var onTap = () {
          paddingCtrl.forward(from: 0.0);
          isFavorited ? onUnfavorite() : onFavorite();
        };
        return _Presenter(
          onTap: onTap,
          isFavorited: isFavorited,
          size: 22.0,
          padding: 2.0 - paddingCtrl.value,
          count: widget.comment.likedByUsers.length + widget.comment.likedByStores.length,
        );
      });
  }
}

class _Presenter extends StatelessWidget {
  final Function onTap;
  final bool isFavorited;
  final double size;
  final double padding;
  final int count;

  _Presenter({Key key, this.onTap, this.isFavorited, this.size, this.padding, this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: padding, bottom: padding),
            width: size,
            height: size,
            child: SvgPicture.asset(
              isFavorited ? 'assets/svgs/like-filled.svg' : 'assets/svgs/like-outlined.svg',
              alignment: Alignment.center,
            ),
          ),
          if (count > 0) Text(count.toString(), style: TextStyle(color: Color(0x81604B41)))
        ],
      ),
    );
  }
}

class _Props {
  final bool isLoggedIn;
  final int myId;
  final Function favoriteComment;
  final Function unfavoriteComment;

  _Props({
    this.isLoggedIn,
    this.myId,
    this.favoriteComment,
    this.unfavoriteComment,
  });

  static fromStore(Store<AppState> store, Comment comment) {
    var me = store.state.me.user;
    return _Props(
      isLoggedIn: me != null,
      myId: me != null ? me.id : 0,
      favoriteComment: (comment) => store.dispatch(FavoriteComment(comment)),
      unfavoriteComment: (comment) => store.dispatch(UnfavoriteComment(comment)),
    );
  }
}
