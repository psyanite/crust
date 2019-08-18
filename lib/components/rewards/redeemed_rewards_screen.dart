import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/rewards/view_mode_icon.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RedeemedRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => _Props.fromStore(store), builder: (context, props) => _Presenter(myId: props.myId));
  }
}

class _Presenter extends StatefulWidget {
  final int myId;

  _Presenter({Key key, this.myId}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  List<Reward> redeemed;
  String currentLayout = 'card';

  @override
  initState() {
    super.initState();
    _load();
  }

  _load() async {
    var userRewards = await MeService.fetchUserRewards(widget.myId);
    this.setState(() {
      redeemed = userRewards.where((u) => u.isRedeemed()).map((u) => u.reward).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), _content()];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
              ],
            ),
            Text('REDEEMED REWARDS', style: Burnt.appBarTitleStyle),
            if (redeemed != null && redeemed.isNotEmpty) Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('All the rewards you\'ve redeemed in the past'),
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
            )
          ],
        ),
      )),
    );
  }

  Widget _content() {
    if (redeemed == null) return LoadingSliver();
    if (redeemed.isEmpty) return _noRewards();
    return RewardCards(rewards: redeemed, layout: currentLayout);
  }

  Widget _noRewards() {
    return CenterTextSliver(text: 'Looks like you haven\'t redeemed any rewards yet.\nDon\'t miss out!');
  }
}

class _Props {
  final int myId;

  _Props({this.myId});

  static fromStore(Store<AppState> store) {
    var me = store.state.me.user;
    return _Props(
      myId: me != null ? me.id : 0,
    );
  }
}
