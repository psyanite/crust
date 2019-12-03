import 'package:crust/components/dialog/dialog.dart';
import 'package:crust/components/rewards/favorite_reward_button.dart';
import 'package:crust/components/rewards/reward_locations_screen.dart';
import 'package:crust/components/rewards/reward_qr_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/reward/reward_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoyaltyCard extends StatefulWidget {
  final Reward reward;
  final int myId;

  LoyaltyCard({Key key, this.reward, this.myId}) : super(key: key);

  @override
  _LoyaltyCardState createState() => _LoyaltyCardState();
}

class _LoyaltyCardState extends State<LoyaltyCard> {
  bool _loading = false;
  UserReward _userReward;

  @override
  initState() {
    super.initState();
    if (widget.myId != null) {
      _fetchUserReward();
    }
  }

  _fetchUserReward() async {
    if (widget.myId == null) return;
    var fresh = await RewardService.fetchUserReward(userId: widget.myId, rewardId: widget.reward.id);
    this.setState(() {
      _userReward = fresh;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.reward == null || _loading == true) return Scaffold(body: LoadingCenter());

    var _refresh = () async {
      _fetchUserReward();
      await Future.delayed(Duration(seconds: 1));
    };
    return Scaffold(
      body: Column(children: <Widget>[
        Flexible(
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: CustomScrollView(slivers: <Widget>[
              SliverToBoxAdapter(child: Column(children: <Widget>[_appBar(), _description()]))
            ]),
          ),
        ),
        _footer(),
      ]),
    );
  }

  _getStarHeight(limit) {
    switch (limit) {
      case 10:
        return 200.0;
      case 9:
        return 150.0;
      case 8:
        return 100.0;
      case 7:
        return 150.0;
      case 6:
        return 150.0;
      case 5:
        return 100.0;
      default:
        return 50.0;
    }
  }

  Widget _stars() {
    var redeemedCount = _userReward != null ? _userReward.redeemedCount : 0;
    var limit = widget.reward.redeemLimit;
    var text = 'Start collecting stars now!';
    if (redeemedCount >= limit) {
      text = 'Congratulations! Visit now to collect your reward.';
    } else if (redeemedCount > 0) {
      text = '${limit - redeemedCount} stars until your reward';
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(height: 20.0),
        Container(
          height: _getStarHeight(limit),
          child: SvgPicture.asset(
            'assets/svgs/stars/${redeemedCount.toString()}-${limit.toString()}.svg',
            alignment: Alignment.center,
          ),
        ),
        Container(height: 20.0),
        Text(text),
      ],
    );
  }

  Widget _appBar() {
    return Column(
      children: <Widget>[
        Stack(
          alignment: AlignmentDirectional.topStart,
          children: <Widget>[
            NetworkImg(widget.reward.promoImage, height: 130.0),
            Container(
              height: 130.0,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0, 0.2, 1.0],
                  colors: [Color(0x30000000), Color(0x30000000), Color(0x0000000)],
                ),
              ),
            ),
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
    var reward = widget.reward;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
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
          Container(height: 30.0),
          _locationDetails(),
          _stars(),
          Container(height: 20.0),
          Text(reward.description),
          Container(height: 10.0),
          _termsAndConditions(),
        ],
      ),
    );
  }

  Widget _locationDetails() {
    if (widget.reward.store != null) {
      return _storeInfo();
    } else {
      return _storeGroupDetails();
    }
  }

  Widget _storeInfo() {
    var store = widget.reward.store;
    return Builder(builder: (context) {
      return InkWell(
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator), bottom: BorderSide(color: Burnt.separator))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(store.name, style: TextStyle(fontSize: 20.0)),
              Container(height: 3.0),
              _address(),
            ],
          ),
        ),
      );
    });
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

  Widget _storeGroupDetails() {
    var group = widget.reward.storeGroup;
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RewardLocationsScreen(group: group))),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          decoration: BoxDecoration(border: Border(top: BorderSide(color: Burnt.separator), bottom: BorderSide(color: Burnt.separator))),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(group.name, style: TextStyle(fontSize: 20.0)),
              Container(height: 7.0),
              Text('Available across ${group.stores.length.toString()} locations'),
              Container(height: 3.0),
              Text(group.stores.map((s) => s.location ?? s.suburb).join(", ")),
              Container(height: 10.0),
              Text('More Information', style: TextStyle(color: Burnt.primaryTextColor)),
            ],
          ),
        ),
      );
    });
  }

  _redirect(UserReward userReward) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RewardQrScreen(userReward: userReward, reward: widget.reward)));
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
    var redeemedCount = _userReward != null ? _userReward.redeemedCount : 0;
    var limit = widget.reward.redeemLimit;
    var text = redeemedCount < limit ? 'Redeem Now' : 'Collect Reward';
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Builder(builder: (context) {
        return BurntButton(onPressed: () => onPressed(context), text: text);
      }),
    );
  }
}
