import 'package:crust/components/rewards/favorite_rewards_screen.dart';
import 'package:crust/components/rewards/loyalty_rewards_screen.dart';
import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/reward/reward_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart' as Geo;
import 'package:redux/redux.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          isLoggedIn: props.isLoggedIn,
          myAddress: props.myAddress,
          nearMe: props.nearMe,
          setMySuburb: props.setMySuburb,
          addNearMe: props.addNearMe,
          clearNearMe: props.clearNearMe,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final Geo.Address myAddress;
  final List<Reward> nearMe;
  final bool nearMeAll;
  final Function setMySuburb;
  final Function addNearMe;
  final Function clearNearMe;

  _Presenter({Key key, this.isLoggedIn, this.nearMe, this.nearMeAll, this.addNearMe, this.myAddress, this.setMySuburb, this.clearNearMe})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie;
  bool _loading = false;
  int _limit = 12;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (widget.nearMe.isNotEmpty && _loading == false && _limit > 0 && _scrollie.position.extentAfter < 500) _getMore();
      });
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.nearMe.length != widget.nearMe.length) {
      _loading = false;
    }
    if (old.myAddress != widget.myAddress) {
      _refresh();
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _refresh() async {
    this.setState(() {
      _limit = 12;
      _loading = true;
    });

    widget.clearNearMe();
    widget.addNearMe(await _fetchRewards(0));
  }

  Future<List<Reward>> _fetchRewards(offset) async {
    return RewardService.fetchRewards(limit: _limit, offset: offset, address: widget.myAddress);
  }

  _getMore() async {
    this.setState(() => _loading = true);
    var fresh = await _fetchRewards(widget.nearMe.length);
    if (fresh.length < _limit) {
      this.setState(() {
        _limit = 0;
        _loading = false;
      });
    }
    if (fresh.isNotEmpty) widget.addNearMe(fresh);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
          await Future.delayed(Duration(milliseconds: 500));
        },
        child: CustomScrollView(
          slivers: <Widget>[
            _appBar(),
            _myFavoritesButton(context),
            _myLoyaltyRewardsButton(context),
            LocationBar(),
            _rewardsList(),
            if (_loading == true) LoadingSliver(),
          ],
          key: PageStorageKey('Rewards'),
          controller: _scrollie,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 6.0, top: 26.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('REWARDS', style: Burnt.appBarTitleStyle),
                  Row(children: <Widget>[_qrIcon()])
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _qrIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.qr, color: Color(0x50604B41), size: 23.0),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQrScreen()));
        },
      );
    });
  }

  Widget _rewardsList() {
    if (widget.nearMe.isEmpty) return LoadingSliverCenter();
    return RewardCards(rewards: widget.nearMe);
  }

  Widget _myFavoritesButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 20.0, bottom: 15.0, left: 16.0, right: 16.0),
        child: BurntButton(
          icon: CrustCons.heart,
          iconSize: 25.0,
          text: 'View My Favourites',
          padding: 10.0,
          fontSize: 20.0,
          onPressed: () {
            if (!widget.isLoggedIn) {
              snack(context, 'Login now to favourite rewards!');
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteRewardsScreen()));
            }
          },
        ),
      ),
    );
  }

  Widget _myLoyaltyRewardsButton(BuildContext context) {
    var onTap = () {
      if (!widget.isLoggedIn) {
        snack(context, 'Login now to redeem rewards!');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoyaltyRewardsScreen()));
      }
    };
    return SliverToBoxAdapter(
      child: Container(
        margin: EdgeInsets.only(bottom: 20.0),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: HollowButton(padding: 8.0, onTap: onTap, children: <Widget>[
          Icon(CrustCons.present, color: Burnt.primaryTextColor, size: 25.0),
          Container(width: 8.0),
          Text('View My Loyalty Rewards', style: TextStyle(fontSize: 20.0, color: Burnt.primaryTextColor)),
        ]),
      ),
    );
  }
}

class _Props {
  final bool isLoggedIn;
  final Geo.Address myAddress;
  final List<Reward> nearMe;
  final Function setMySuburb;
  final Function addNearMe;
  final Function clearNearMe;

  _Props({
    this.isLoggedIn,
    this.myAddress,
    this.nearMe,
    this.setMySuburb,
    this.addNearMe,
    this.clearNearMe,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
      myAddress: store.state.me.address ?? Utils.defaultAddress,
      nearMe: List<Reward>.from(Utils.subset(store.state.reward.nearMe, store.state.reward.rewards)),
      setMySuburb: (address) => store.dispatch(SetMyAddress(address)),
      addNearMe: (rewards) => store.dispatch(FetchRewardsNearMeSuccess(rewards)),
      clearNearMe: () => store.dispatch(ClearNearMe()),
    );
  }
}
