import 'package:crust/components/favorite_button.dart';
import 'package:crust/components/screens/qr_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RewardScreen extends StatelessWidget {
  final int rewardId;

  RewardScreen({Key key, this.rewardId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) => store.dispatch(FetchUserRewardRequest(rewardId)),
        converter: (Store<AppState> store) => _Props.fromStore(store, rewardId),
        builder: (context, props) => _Presenter(
            reward: props.reward,
            userReward: props.userReward,
            favoriteRewards: props.favoriteRewards,
            favoriteReward: props.favoriteReward,
            unfavoriteReward: props.unfavoriteReward,
            addUserReward: props.addUserReward,
            isLoggedIn: props.isLoggedIn));
  }
}

class _Presenter extends StatelessWidget {
  final Reward reward;
  final UserReward userReward;
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final Function addUserReward;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.reward,
      this.userReward,
      this.favoriteReward,
      this.favoriteRewards,
      this.unfavoriteReward,
      this.addUserReward,
      this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[Column(
      children: <Widget>[
        _appBar(),
        _description()
      ],
    ), _footer()])));
  }

  Widget _appBar() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
                height: 150.0,
                decoration: BoxDecoration(
                  color: Burnt.imgPlaceholderColor,
                  image: DecorationImage(
                    image: NetworkImage(reward.promoImage),
                    fit: BoxFit.cover,
                  ),
                )),
            SafeArea(
              child: Container(
                height: 55.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BackArrow(color: Colors.white),
                    Padding(child: _favoriteButton(reward), padding: EdgeInsets.only(right: 10.0))
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(bottom: 5.0),
            child: Text(reward.name, style: Burnt.display4),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(reward.bannerText()),
              Container(height: 10.0),
              _location(reward),
              Container(height: 10.0),
              Text(reward.description),
            ],
          )
        ],
      ),
    );
  }

  Widget _location(Reward reward) {
    var content = <Widget>[];
    if (reward.store != null) {
      var store = reward.store;
      content.add(Text(store.name));
      store.address.firstLine != null ?? content.add(Text(store.address.firstLine));
      store.address.secondLine != null ?? content.add(Text(store.address.secondLine));
      content.add(Text("${store.address.streetNumber} ${store.address.streetName}"));
      content.add(Text(store.location ?? store.suburb));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: content,
    );
  }

  Widget _footer() {
    return userReward?.isRedeemed() == true ? Text('You\'ve already redeemed this reward!') : _redeemContent();
  }

  Widget _redeemContent() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Builder(
        builder: (context) => SolidButton(
              onPressed: () {
                if (!isLoggedIn) {
                  snack(context, 'Login to start redeeming rewards!');
                } else {
                  if (userReward == null) {
                    addUserReward(reward.id);
                  }
                  while (userReward == null) {}
                  Navigator.push(context, MaterialPageRoute(builder: (_) => QrScreen(userReward: userReward)));
                }
              },
              text: 'Redeem Now',
            ),
      ),
    );
  }

  Widget _favoriteButton(Reward reward) {
    return Builder(
      builder: (context) => FavoriteButton(
            padding: 0,
            isFavorited: favoriteRewards.contains(reward.id),
            onFavorite: () {
              if (isLoggedIn) {
                favoriteReward(reward.id);
                snack(context, 'Added to favourites');
              } else {
                snack(context, 'Please login to favourite reward');
              }
            },
            onUnfavorite: () {
              unfavoriteReward(reward.id);
              snack(context, 'Removed from favourites');
            },
          ),
    );
  }
}

class _Props {
  final Reward reward;
  final UserReward userReward;
  final Set<int> favoriteRewards;
  final Function favoriteReward;
  final Function unfavoriteReward;
  final Function addUserReward;
  final bool isLoggedIn;

  _Props({
    this.reward,
    this.userReward,
    this.favoriteRewards,
    this.favoriteReward,
    this.unfavoriteReward,
    this.addUserReward,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store, int rewardId) {
    return _Props(
      reward: store.state.reward.rewards[rewardId],
      userReward: store.state.me.userReward,
      favoriteRewards: store.state.me.favoriteRewards ?? Set<int>(),
      favoriteReward: (rewardId) => store.dispatch(FavoriteRewardRequest(rewardId)),
      unfavoriteReward: (rewardId) => store.dispatch(UnfavoriteRewardRequest(rewardId)),
      addUserReward: (rewardId) => store.dispatch(AddUserRewardRequest(rewardId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
