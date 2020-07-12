import 'package:crust/components/dialog/confirm.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FollowUserButton extends StatelessWidget {
  final int userId;
  final String displayName;
  final Widget followView;
  final Widget followedView;

  FollowUserButton({Key key, this.userId, this.displayName, this.followView, this.followedView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store, userId),
      builder: (context, props) {
        return _Presenter(
          userId: userId,
          displayName: displayName,
          followView: followView,
          followedView: followedView,
          isFollowed: props.isFollowed,
          follow: props.follow,
          unfollow: props.unfollow,
          isLoggedIn: props.isLoggedIn,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final int userId;
  final String displayName;
  final Widget followView;
  final Widget followedView;
  final bool isFollowed;
  final Function follow;
  final Function unfollow;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.userId,
      this.displayName,
      this.followView,
      this.followedView,
      this.isFollowed,
      this.follow,
      this.unfollow,
      this.isLoggedIn})
      : super(key: key);

  onUnfollow(BuildContext context) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Confirm(
          title: 'Unfollow User',
          description: 'Would you like to unfollow this user?',
          action: 'Unfollow',
          onTap: () {
            unfollow();
            Navigator.of(context, rootNavigator: true).pop(true);
          },
        );
      },
    );
  }

  onFollow(BuildContext context) async {
    if (isLoggedIn == false) {
      loginSnack(context, 'Login now to follow users');
      return;
    }
    follow();
    snack(context, '🎉 You\'re now following $displayName');
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => isFollowed ? onUnfollow(context) : onFollow(context),
      child: isFollowed ? followedView : followView,
    );
  }
}

class _Props {
  final bool isFollowed;
  final Function follow;
  final Function unfollow;
  final bool isLoggedIn;

  _Props({
    this.isFollowed,
    this.follow,
    this.unfollow,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store, int userId) {
    return _Props(
      isFollowed: store.state.follow.users.contains(userId),
      follow: () => store.dispatch(FollowUser(userId)),
      unfollow: () => store.dispatch(UnfollowUser(userId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
