import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/search/select_suburb_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class RewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          isLoggedIn: props.isLoggedIn,
          refresh: props.refresh,
          nearMe: props.nearMe,
          fetchRewards: props.fetchRewards,
          mySuburb: props.mySuburb,
          setMySuburb: props.setMySuburb,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final Function refresh;
  final List<Reward> nearMe;
  final Function fetchRewards;
  final MyStore.Suburb mySuburb;
  final Function setMySuburb;

  _Presenter({Key key, this.isLoggedIn, this.refresh, this.nearMe, this.fetchRewards, this.mySuburb, this.setMySuburb}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie;
  List<Reward> _nearMe;
  bool _loading = false;
  bool _loadingLocation = false;

//  int _limit = 7;
  int _limit = 3;

//  int _offset = 7;
  int _offset = 3;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (_loading == false && _limit > 0 && _scrollie.position.extentAfter < 500) _getMoreRewards();
      });
    _nearMe = widget.nearMe;
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.nearMe.length < widget.nearMe.length) {
      _nearMe = widget.nearMe;
      _offset = _offset + _limit;
      _loading = false;
    }

//    if (_loading == true) {
//      if (old.nearMe.length == widget.nearMe.length) {
//        _limit = 0;
//      } else if (old.nearMe.length < widget.nearMe.length) {
//        _nearMe = widget.nearMe;
//        _offset = _offset + _limit;
//      }
//      _loading = false;
//    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _getMoreRewards() async {
    if (_limit > 0) {
      this.setState(() => _loading = true);
      widget.fetchRewards(_limit, _offset);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          widget.refresh();
          await Future.delayed(Duration(seconds: 1));
        },
        child: CustomScrollView(
          slivers: <Widget>[_appBar(), _locationBar(context), _rewardsList()],
          controller: _scrollie,
          physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        ),
      ),
    );
  }

  Widget _locationBar(context) {
    return SliverToBoxAdapter(
      child: widget.mySuburb != null ? _suburbInfo(context, widget.mySuburb) : _defaultSuburbInfo(context),
    );
  }

  Widget _suburbInfo(context, suburb) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => SelectSuburbScreen(selectLocation: () {})));
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
                  Text(suburb.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text('${suburb.city}, ${suburb.district}', style: TextStyle(fontSize: 18.0)),
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

  Widget _defaultSuburbInfo(context) {
    var suburb =
        MyStore.Suburb(id: 1, name: 'Sydney CBD', postcode: 2000, city: 'Sydney', district: 'NSW', lat: -33.794883, lng: 151.268071);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _suburbInfo(context, suburb),
        InkWell(
          onTap: () => _getLocation(context),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: _loadingLocation == true
                ? Container(
                    width: 100.0,
                    child: Center(child: Container(width: 20.0, height: 20.0, child: CircularProgressIndicator(strokeWidth: 3.0))))
                : Text("Use My Location", style: TextStyle(color: Burnt.primaryTextColor)),
          ),
        ),
      ],
    );
  }

  _getLocation(context) async {
    var enabled = await Geolocator().isLocationServiceEnabled();
    if (enabled == false) {
      snack(context, 'Oops! Looks like your device location is not turned on');
      return;
    }
    this.setState(() => _loadingLocation = true);
    var p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: 10));
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(p.latitude, p.longitude)).timeout(Duration(seconds: 10));
    if (addresses.isNotEmpty) {
      var a = addresses[0];
      var result = await SearchService.findSuburbByName(a.locality);
      if (result != null) {
        widget.setMySuburb(result);
        this.setState(() => _loadingLocation = false);
        return;
      }
      var results = await SearchService.findSuburbsByQuery(a.locality, a.postalCode);
      if (results.isNotEmpty) {
        widget.setMySuburb(results[0]);
        this.setState(() => _loadingLocation = false);
        return;
      }
    }
  }

  Widget _rewardsList() {
    if (_nearMe.isEmpty) return LoadingSliver();
    return RewardCards(rewards: _nearMe);
  }
}

class _Props {
  final bool isLoggedIn;
  final Function refresh;
  final List<Reward> nearMe;
  final Function fetchRewards;
  final MyStore.Suburb mySuburb;
  final Function setMySuburb;

  _Props({
    this.isLoggedIn,
    this.refresh,
    this.nearMe,
    this.fetchRewards,
    this.mySuburb,
    this.setMySuburb,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
      refresh: () {
//          store.dispatch(FetchRewardsNearMe(7, 0));
        store.dispatch(FetchRewardsNearMe(3, 0));
      },
      nearMe: List<Reward>.from(Utils.subset(store.state.reward.nearMe, store.state.reward.rewards)),
      fetchRewards: (limit, offset) => store.dispatch(FetchRewardsNearMe(limit, offset)),
      mySuburb: store.state.me.suburb,
      setMySuburb: (suburb) => store.dispatch(SetMySuburb(suburb)),
    );
  }
}
