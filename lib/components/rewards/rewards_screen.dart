import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/search/select_address_screen.dart';
import 'package:crust/components/search/use_my_location.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/geocoder.dart' as Geo;
import 'package:redux/redux.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          myAddress: props.myAddress,
          nearMe: props.nearMe,
          nearMeAll: props.nearMeAll,
          fetchRewards: props.fetchRewards,
          setMySuburb: props.setMySuburb,
          clearRewards: props.clearRewards,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Geo.Address myAddress;
  final List<Reward> nearMe;
  final bool nearMeAll;
  final Function fetchRewards;
  final Function setMySuburb;
  final Function clearRewards;

  _Presenter(
      {Key key, this.nearMe, this.nearMeAll, this.fetchRewards, this.myAddress, this.setMySuburb, this.clearRewards})
      : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  final Geo.Address defaultAddress =
      Geo.Address(coordinates: Coordinates(-33.794883, 151.268071), addressLine: 'Sydney CBD', locality: 'Sydney', postalCode: '2000');
  ScrollController _scrollie;
  List<Reward> _nearMe;
  bool _loading = false;
  int _limit = 3;
  int _offset = 0;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (widget.nearMe.isNotEmpty && _loading == false && _limit > 0 && _scrollie.position.extentAfter < 200) _getMoreRewards();
      });
    _nearMe = widget.nearMe;
    if (_nearMe.isEmpty) widget.fetchRewards(_limit, _offset, widget.myAddress ?? defaultAddress);
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.nearMe.length != widget.nearMe.length) {
      _nearMe = widget.nearMe;
      _offset = _offset + _limit;
      _loading = false;
    }
    if (widget.nearMeAll == true) {
      _limit = 0;
      _loading = false;
    }
    if (old.myAddress != widget.myAddress) {
      _refresh(widget.myAddress);
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _refresh(Geo.Address a) {
    this.setState(() => {
          _limit = 3,
          _offset = 0,
          _loading = false,
        });
    widget.clearRewards();
    widget.fetchRewards(_limit, _offset, a ?? defaultAddress);
  }

  _getMoreRewards() {
    if (_limit > 0) {
      this.setState(() => _loading = true);
      widget.fetchRewards(_limit, _offset, widget.myAddress ?? defaultAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh(widget.myAddress);
          await Future.delayed(Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[_appBar(), _locationBar(context), _rewardsList(), if (_loading == true) LoadingSliver()],
          controller: _scrollie,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }

  Widget _locationBar(context) {
    return SliverToBoxAdapter(
      child: widget.myAddress != null ? _suburbInfo(context, widget.myAddress) : _defaultAddressInfo(context),
    );
  }

  Widget _suburbInfo(context, Geo.Address address) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SelectAddressScreen()));
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(height: 10.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(width: 14.0),
              Container(margin: EdgeInsets.only(top: 10.0), child: Icon(CrustCons.location_bold, color: Burnt.lightGrey, size: 22.0)),
              Container(width: 12.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(address.addressLine.split(',')[0] ?? '', style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text(address.locality ?? '', style: TextStyle(fontSize: 18.0)),
                  Container(height: 10.0)
                ],
              ),
              Container(
                  margin: EdgeInsets.only(left: 5.0, top: 10.0), child: Icon(Icons.keyboard_arrow_down, color: Burnt.primary, size: 30.0))
            ],
          ),
          Container(height: 10.0),
        ],
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
                  Row(
                    children: <Widget>[_qrIcon()],
                  )
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

  Widget _defaultAddressInfo(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _suburbInfo(context, defaultAddress),
        UseMyLocation(),
      ],
    );
  }

  Widget _rewardsList() {
    if (_nearMe.isEmpty) return LoadingSliverCenter();
    return RewardCards(rewards: _nearMe);
  }
}

class _Props {
  final Geo.Address myAddress;
  final List<Reward> nearMe;
  final bool nearMeAll;
  final Function fetchRewards;
  final Function setMySuburb;
  final Function clearRewards;

  _Props({
    this.myAddress,
    this.nearMe,
    this.nearMeAll,
    this.fetchRewards,
    this.setMySuburb,
    this.clearRewards,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      myAddress: store.state.me.address,
      nearMe: List<Reward>.from(Utils.subset(store.state.reward.nearMe, store.state.reward.rewards)),
      nearMeAll: store.state.reward.nearMeAll,
      fetchRewards: (limit, offset, Address a) =>
          store.dispatch(FetchRewardsNearMe(a.coordinates.latitude, a.coordinates.longitude, limit, offset)),
      setMySuburb: (address) => store.dispatch(SetMyAddress(address)),
      clearRewards: () => store.dispatch(ClearNearMe()),
    );
  }
}
