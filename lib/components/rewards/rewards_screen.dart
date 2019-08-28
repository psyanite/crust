import 'package:crust/components/rewards/favorite_rewards_screen.dart';
import 'package:crust/components/rewards/redeemed_rewards_screen.dart';
import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/rewards/reward_swiper.dart';
import 'package:crust/components/rewards/view_mode_icon.dart';
import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/search/search_screen.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
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
          topRewards: props.topRewards,
          nearMe: props.nearMe,
          fetchRewards: props.fetchRewards,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final Function refresh;
  final List<Reward> topRewards;
  final List<Reward> nearMe;
  final Function fetchRewards;

  _Presenter({Key key, this.isLoggedIn, this.refresh, this.topRewards, this.nearMe, this.fetchRewards}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String currentLayout = 'card';
  ScrollController _scrollie;
  List<Reward> nearMe;
  bool loading = false;
  int limit = 7;
  int offset = 7;

  @override
  initState() {
    super.initState();
    _scrollie = ScrollController()
      ..addListener(() {
        if (loading == false && limit > 0 && _scrollie.position.extentAfter < 500) _getMoreRewards();
      });
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (loading == true) {
      if (old.nearMe.length == widget.nearMe.length) {
        limit = 0;
      } else if (old.nearMe.length < widget.nearMe.length) {
        nearMe = widget.nearMe;
        offset = offset + limit;
      }
      loading = false;
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _scrollie.dispose();
    super.dispose();
  }

  _getMoreRewards() async {
    if (limit > 0) {
      this.setState(() => loading = true);
      widget.fetchRewards(limit, offset);
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
          slivers: <Widget>[
            _appBar(),
            _seeRedeemedButton(context),
            _myRewardsButton(context),
            _topRewards(context),
            _rewardsListTitle(),
            _rewardsList()
          ],
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
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 33.0, bottom: 30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('REWARDS', style: Burnt.appBarTitleStyle),
                  Row(
                    children: <Widget>[_searchIcon(), _qrIcon()],
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 21.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
      );
    });
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

  Widget _seeRedeemedButton(BuildContext context) {
    var onTap = () {
      if (!widget.isLoggedIn) {
        snack(context, 'Login now to redeem rewards!');
      } else {
        Navigator.push(context, MaterialPageRoute(builder: (_) => RedeemedRewardsScreen()));
      }
    };
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: HollowButton(padding: 8.0, onTap: onTap, children: <Widget>[
          Icon(CrustCons.present, color: Burnt.primaryTextColor, size: 25.0),
          Container(width: 8.0),
          Text('View Redeemed Rewards', style: TextStyle(fontSize: 20.0, color: Burnt.primaryTextColor)),
        ]),
      ),
    );
  }

  Widget _myRewardsButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0, left: 16.0, right: 16.0),
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

  Widget _topRewards(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          RewardSwiper(
            rewards: widget.topRewards,
            header: Padding(
              padding: EdgeInsets.only(top: 40.0, bottom: 15.0),
              child: Text('TOP PICKS 👍', style: Burnt.appBarTitleStyle.copyWith(color: Burnt.hintTextColor)),
            ),
          ),
          Container(height: 20.0),
        ],
      ),
    );
  }

  Widget _rewardsListTitle() {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 25.0, left: 16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text('Rewards near you'),
            ViewModeIcon(toggleLayout: () {
              setState(() {
                if (currentLayout == 'card') {
                  currentLayout = 'list';
                } else {
                  currentLayout = 'card';
                }
              });
            })
          ],
        ),
      ),
    );
  }

  Widget _rewardsList() {
    var rewards = widget.nearMe;
    if (rewards.isEmpty) return LoadingSliver();
    return RewardCards(rewards: rewards, layout: currentLayout);
  }
}

class _Props {
  final bool isLoggedIn;
  final Function refresh;
  final List<Reward> topRewards;
  final List<Reward> nearMe;
  final Function fetchRewards;

  _Props({
    this.isLoggedIn,
    this.refresh,
    this.topRewards,
    this.nearMe,
    this.fetchRewards,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
      refresh: () {
        store.dispatch(FetchRewardsNearMe(7, 0));
        store.dispatch(FetchTopRewards());
      },
      topRewards: store.state.reward.topRewards.values.toList(),
      nearMe: List<Reward>.from(Utils.subset(store.state.reward.nearMe, store.state.reward.rewards)),
      fetchRewards: (limit, offset) => store.dispatch(FetchRewardsNearMe(limit, offset)),
    );
  }
}
