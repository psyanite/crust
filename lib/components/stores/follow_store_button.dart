import 'package:crust/components/dialog/confirm.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/follow/follow_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FollowStoreButton extends StatelessWidget {
  final int storeId;
  final String storeName;
  final Widget followView;
  final Widget followedView;

  FollowStoreButton({Key key, this.storeId, this.storeName, this.followView, this.followedView}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store, storeId),
      builder: (context, props) {
        return _Presenter(
          storeId: storeId,
          storeName: storeName,
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
  final int storeId;
  final String storeName;
  final Widget followView;
  final Widget followedView;
  final bool isFollowed;
  final Function follow;
  final Function unfollow;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.storeId,
      this.storeName,
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
          title: 'Unfollow Store',
          description: 'Would you like to unfollow this store?',
          action: 'Unfollow',
          onTap: () {
            unfollow();
            Navigator.of(context, rootNavigator: true).pop(true);
            snack(context, 'Unfollowed $storeName');
          },
        );
      },
    );
  }

  onFollow(BuildContext context) async {
    if (isLoggedIn == false) {
      snack(context, 'Login now to follow stores');
      return;
    }
    follow();
    snack(context, 'Now following $storeName');
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

  static fromStore(Store<AppState> store, int storeId) {
    return _Props(
      isFollowed: store.state.follow.stores.contains(storeId),
      follow: () => store.dispatch(FollowStore(storeId)),
      unfollow: () => store.dispatch(UnfollowStore(storeId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
