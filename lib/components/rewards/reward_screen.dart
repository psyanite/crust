import 'package:crust/components/dialog/dialog.dart';
import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/loyalty_card.dart';
import 'package:crust/components/rewards/reward_locations_screen.dart';
import 'package:crust/components/rewards/reward_qr_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/reward/reward_service.dart';
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
      converter: (Store<AppState> store) => _Props.fromStore(store, rewardId),
      builder: (context, props) {
        if (props.reward?.type == RewardType.loyalty) {
          return LoyaltyCard(reward: props.reward, myId: props.myId);
        }
        return _Presenter(reward: props.reward, myId: props.myId);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Reward reward;
  final int myId;

  _Presenter({Key key, this.reward, this.myId}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  UserReward _userReward;

  @override
  initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (widget.myId != null) {
      var fresh = await RewardService.fetchUserReward(userId: widget.myId, rewardId: widget.reward.id);
      if (fresh != null) this.setState(() => _userReward = fresh);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reward == null) return Scaffold(body: LoadingCenter());

    return Scaffold(
      body: Column(children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: _load,
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(child: Column(children: <Widget>[_appBar(), _description()]))
            ]),
          ),
        ),
        _footer(),
      ]),
    );
  }

  Widget _appBar() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            NetworkImg(widget.reward.promoImage, height: 300.0),
            Container(
              height: 300.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.8],
                  colors: [Color(0x00000000), Color(0x30000000)],
                ),
              ),
            ),
            SafeArea(
              child: Container(
                height: 60.0,
                child: BackArrow(color: Colors.white),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _description() {
    var reward = widget.reward;
    var count = _userReward?.lastRedeemedAt != null && reward.type == RewardType.unlimited
        ? 'You\'ve redeemed this ${_userReward.redeemedCount} times'
        : null;
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
              FavoriteRewardButton(reward: reward, size: 30.0)
            ],
          ),
          Text(reward.bannerText()),
          Container(height: 5.0),
          if (count != null) Text(count),
          Container(height: 30.0),
          if (reward.isHidden()) _secretBanner(),
          _locationDetails(),
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
        builder: (context) {
          return BurntDialog(
            options: options,
            description:
                'Secret rewards do not show up when browsing the app, they can only be accessed via a shared link or a QR code. Save it to your favourites or you may not find it again!',
          );
        },
      );
    };
    var content = Container(
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
      ),
    );
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => onTap(context),
        child: content,
      );
    });
  }

  Widget _locationDetails() {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator), bottom: BorderSide(color: Burnt.separator))),
        child: Row(children: <Widget>[
          Expanded(child: widget.reward.store != null ? _storeInfo(context) : _storeGroupDetails(context)),
        ]),
      );
    });
  }

  Widget _storeInfo(context) {
    var store = widget.reward.store;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(store.name, style: TextStyle(fontSize: 20.0)),
                Container(height: 3.0),
                _address(),
              ],
            ),
          ),
          _chevronRight()
        ],
      ),
    );
  }

  Widget _address() {
    var store = widget.reward.store;
    var address = store.address;
    if (address == null) return Container();
    var first = store.getFirstLine();
    var second = store.getSecondLine();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (first.isNotEmpty) Text(first),
        if (second.isNotEmpty) Text(second),
      ],
    );
  }

  Widget _storeGroupDetails(context) {
    var group = widget.reward.storeGroup;
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardLocationsScreen(group: group))),
      child: Row(children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(group.name, style: TextStyle(fontSize: 20.0)),
              Container(height: 7.0),
              Text('Available across ${group.stores.length.toString()} locations'),
              Container(height: 3.0),
              Text(group.stores.map((s) => s.location ?? s.suburb).join(', ')),
              Container(height: 10.0),
              Text('More Information', style: TextStyle(color: Burnt.primaryTextColor)),
            ],
          ),
        ),
        _chevronRight(),
      ]),
    );
  }

  Widget _chevronRight() {
    return Icon(Icons.chevron_right, color: Burnt.iconOrange, size: 30.0);
  }

  Widget _termsAndConditions() {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          var options = <DialogOption>[DialogOption(display: 'OK', onTap: () => Navigator.of(context, rootNavigator: true).pop(true))];
          showDialog(context: context, builder: (context) => TermsDialog(options: options, terms: widget.reward.termsAndConditions));
        },
        child: Text(
          'Terms & Conditions',
          style: TextStyle(color: Burnt.primaryTextColor),
        ),
      );
    });
  }

  Widget _footer() {
    if (_userReward?.isRedeemed(widget.reward) == true) {
      return _renderFooterText('You\'ve already redeemed this reward!');
    } else if (widget.reward.isExpired() == true) {
      return _renderFooterText('Sorry, this reward has already expired!');
    }
    return _redeemButton();
  }

  Widget _renderFooterText(text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 40.0),
      child: Center(child: Text(text)),
    );
  }

  Widget _redeemButton() {
    var onPressed = (BuildContext context) async {
      if (widget.myId == null) {
        snack(context, 'Login to start redeeming rewards!');
        return;
      }
      if (_userReward != null) {
        _redirect(_userReward);
        return;
      }
      var update = await RewardService.addUserReward(userId: widget.myId, rewardId: widget.reward.id);
      this.setState(() => _userReward = update);
      _redirect(update);
    };
    var text = widget.reward.type == RewardType.unlimited
        ? 'Redeem this reward as many times as you like'
        : 'This reward can only be redeemed once';
    return Column(
      children: <Widget>[
        Text(text),
        Padding(
          padding: EdgeInsets.all(16.0),
          child: Builder(builder: (context) {
            return BurntButton(onPressed: () => onPressed(context), text: 'Redeem Now');
          }),
        ),
      ],
    );
  }

  _redirect(UserReward userReward) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RewardQrScreen(userReward: userReward, reward: widget.reward)));
  }
}

class _Props {
  final int myId;
  final Reward reward;

  _Props({
    this.myId,
    this.reward,
  });

  static fromStore(Store<AppState> store, int rewardId) {
    return _Props(
      myId: store.state.me.user?.id,
      reward: store.state.reward.rewards[rewardId],
    );
  }
}
