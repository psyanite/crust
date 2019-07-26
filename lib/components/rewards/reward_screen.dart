import 'package:crust/components/dialog.dart';
import 'package:crust/components/rewards/favorite_reward_button.dart';
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
  final UserReward userReward;

  RewardScreen({Key key, this.rewardId, this.userReward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) {
          if (rewardId != null) store.dispatch(FetchUserRewardRequest(rewardId));
        },
        converter: (Store<AppState> store) =>_Props.fromStore(store, rewardId),
        builder: (context, props) => _Presenter(
            reward: userReward?.reward ?? props.reward,
            userReward: userReward ?? props.userReward,
            addUserReward: props.addUserReward,
            isLoggedIn: props.isLoggedIn));
  }
}

class _Presenter extends StatelessWidget {
  final Reward reward;
  final UserReward userReward;
  final Function addUserReward;
  final bool isLoggedIn;

  _Presenter(
      {Key key,
      this.reward,
      this.userReward,
      this.addUserReward,
      this.isLoggedIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
          Column(
            children: <Widget>[_appBar(), _description()],
          ),
          _footer()
        ])));
  }

  Widget _appBar() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            Container(
                height: 300.0,
                decoration: BoxDecoration(
                  color: Burnt.imgPlaceholderColor,
                  image: DecorationImage(
                    image: NetworkImage(reward.promoImage),
                    fit: BoxFit.cover,
                  ),
                )),
            Container(height: 150.0, decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0, 0.2, 1.0],
                colors: [Color(0x30000000), Color(0x30000000), Color(0x0000000)],
              ))),
            SafeArea(
              child: Container(
                height: 106.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    BackArrow(color: Colors.white),
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
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(bottom: 5.0),
                child: Text(reward.name, style: Burnt.display4),
              ),
              Padding(child: FavoriteRewardButton(reward: reward, size: 30.0), padding: EdgeInsets.only(right: 10.0))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(reward.bannerText()),
              Container(height: 10.0),
              _location(reward),
              Container(height: 10.0),
              Text(reward.description),
              Container(height: 10.0),
              _termsAndConditions(),
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

  Widget _termsAndConditions() {
    return Builder(builder: (context) {
      return InkWell(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () {
            var options = <DialogOption>[DialogOption(display: 'OK', onTap: () => Navigator.of(context, rootNavigator: true).pop(true))];
            showDialog(context: context, builder: (context) => BurntDialog(options: options, description: reward.termsAndConditions));
          },
          child: Text('See terms and conditions', style: TextStyle(color: Burnt.primaryTextColor)));
    });
  }

  Widget _footer() {
    if (userReward?.isRedeemed() == true) {
      return _renderFooterText('You\'ve already redeemed this reward!');
    } else if (reward.isExpired() == true) {
      return _renderFooterText('Sorry, this reward has already expired!');
    }
    return _redeemContent();
  }

  Widget _renderFooterText(text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
      child: Center(
        child: Text(text),
      ),
    );
  }

  Widget _redeemContent() {
    return Padding(
      padding: EdgeInsets.all(16.0),
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
}

class _Props {
  final Reward reward;
  final UserReward userReward;
  final Function addUserReward;
  final bool isLoggedIn;

  _Props({
    this.reward,
    this.userReward,
    this.addUserReward,
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store, int rewardId) {
    return _Props(
      reward: rewardId != null ? store.state.reward.rewards[rewardId] : null,
      userReward: rewardId != null ? store.state.me.userReward : null,
      addUserReward: (rewardId) => store.dispatch(AddUserRewardRequest(rewardId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
