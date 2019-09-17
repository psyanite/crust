import 'package:crust/components/common/confirm.dart';
import 'package:crust/components/common/favorite_button.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/favorite/favorite_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class FavoriteRewardButton extends StatelessWidget {
  final Reward reward;
  final double size;
  final EdgeInsets padding;
  final bool confirmUnfavorite;

  FavoriteRewardButton({Key key, this.reward, this.size, this.padding, this.confirmUnfavorite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) {
        return _Presenter(
          reward: reward,
          size: size,
          padding: padding,
          confirmUnfavorite: confirmUnfavorite,
          favoriteRewards: props.favoriteRewards,
          favoriteReward: props.favoriteReward,
          unfavoriteReward: props.unfavoriteReward,
          isLoggedIn: props.isLoggedIn,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final Reward reward;
  final double size;
  final EdgeInsets padding;
  final bool confirmUnfavorite;
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.reward,
      this.size,
      this.padding,
      this.confirmUnfavorite = false,
      this.favoriteRewards,
      this.favoriteReward,
      this.unfavoriteReward,
      this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FavoriteButton(
      padding: padding,
      size: size,
      isFavorited: favoriteRewards.contains(reward.id),
      onFavorite: () {
        if (reward.isExpired() == true) {
          snack(context, 'Expired rewards cannot be favorited');
        } else if (isLoggedIn) {
          favoriteReward(reward.id);
          snack(context, 'Added to favourites');
        } else {
          snack(context, 'Login now to favourite rewards');
        }
      },
      onUnfavorite: () {
        if (confirmUnfavorite == true) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Confirm(
                title: 'Remove Reward',
                description: 'This reward will be removed from favorites',
                action: 'Remove',
                onTap: () {
                  unfavoriteReward(reward.id);
                  Navigator.of(context, rootNavigator: true).pop(true);
                },
              );
            },
          );
        } else {
          unfavoriteReward(reward.id);
          snack(context, 'Removed from favourites');
        }
      },
    );
  }
}

class _Props {
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final bool isLoggedIn;

  _Props({
    this.favoriteRewards,
    this.favoriteReward,
    this.unfavoriteReward,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      favoriteRewards: store.state.favorite.rewards,
      favoriteReward: (rewardId) => store.dispatch(FavoriteReward(rewardId)),
      unfavoriteReward: (rewardId) => store.dispatch(UnfavoriteReward(rewardId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
