import 'package:crust/components/dialog.dart';
import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/screens/reward_qr_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RewardScreen extends StatelessWidget {
  final Reward reward;
  final int rewardId;
  final UserReward userReward;

  RewardScreen({Key key, this.reward, this.rewardId, this.userReward}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        onInit: (Store<AppState> store) {
          if (reward != null) store.dispatch(FetchRewardSuccess(reward));
          if (rewardId != null) store.dispatch(FetchUserRewardRequest(rewardId));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store, userReward, rewardId),
        builder: (context, props) {
          return _Presenter(
              reward: props.reward, userReward: props.userReward, addUserReward: props.addUserReward, isLoggedIn: props.isLoggedIn);
        });
  }
}

class _Presenter extends StatelessWidget {
  final Reward reward;
  final UserReward userReward;
  final Function addUserReward;
  final bool isLoggedIn;
  final String error;

  _Presenter({Key key, this.reward, this.userReward, this.addUserReward, this.isLoggedIn, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (error != null) return Scaffold(body: Center(child: Text(error)));
    if (reward == null) return Scaffold(body: LoadingCenter());
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
            Container(
                height: 150.0,
                decoration: BoxDecoration(
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
      padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
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
          Text(reward.bannerText()),
          Container(height: 30.0),
          if (reward.isHidden()) _secretBanner(),
          _storeDetails(),
          Container(height: 20.0),
          Text(reward.description),
          Container(height: 10.0),
          _termsAndConditions(),
        ],
      ),
    );
  }

  Widget _secretBanner() {
    var onTap = (BuildContext context) {
      var options = <DialogOption>[DialogOption(display: 'OK', onTap: () => Navigator.of(context, rootNavigator: true).pop(true))];
      showDialog(
        context: context,
        builder: (context) => BurntDialog(
          options: options,
          description: 'Secret rewards do not show up when browsing the app, they can only be accessed via a shared link or a QR code. Save it to your favourites or you may not find it again!'));
    };
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => onTap(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.0),
            decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator))),
            child: Row(
              children: <Widget>[
                Text('🎉', style: TextStyle(fontSize: 55.0)),
                Container(width: 15.0),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Congratulations!', style: TextStyle(fontWeight: Burnt.fontBold, color: Burnt.hintTextColor)),
                      Text('You\'ve unlocked a secret reward.'),
                      Text('Make sure you save it to your favourites!'),
                    ],
                  ),
                )
              ],
            )),
        );
      }
    );
  }

  Widget _storeDetails() {
    var store = reward.store;
    if (store == null) return Container();
    var content = <Widget>[
      Text(store.name, style: TextStyle(fontSize: 20.0)),
      Container(height: 3.0),
      if (store.address.firstLine != null) Text(store.address.firstLine),
      if (store.address.secondLine != null) Text(store.address.secondLine),
      Text("${store.address.streetNumber} ${store.address.streetName}"),
      if (store.location != null) Text(store.location),
      if (store.suburb != null) Text(store.suburb),
    ];
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator), bottom: BorderSide(color: Burnt.separator))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: content,
              ),
            ),
        );
      });
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
    var onPressed = (BuildContext context) {
      if (!isLoggedIn) {
        snack(context, 'Login to start redeeming rewards!');
      } else {
        if (userReward == null) {
          addUserReward(reward.id);
        }
        while (userReward == null) {}
        Navigator.push(context, MaterialPageRoute(builder: (_) => RewardQrScreen(userReward: userReward)));
      }
    };
    return Padding(
        padding: EdgeInsets.all(16.0),
        child: Builder(builder: (context) {
          return SolidButton(
            onPressed: () => onPressed(context),
            text: 'Redeem Now',
          );
        }));
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

  static fromStore(Store<AppState> store, UserReward userReward, int rewardId) {
    return _Props(
      reward: userReward?.reward ?? (rewardId != null ? store.state.reward.rewards[rewardId] : null),
      userReward: userReward ?? store.state.me.userReward,
      addUserReward: (rewardId) => store.dispatch(AddUserRewardRequest(rewardId)),
      isLoggedIn: store.state.me.user != null,
    );
  }
}
