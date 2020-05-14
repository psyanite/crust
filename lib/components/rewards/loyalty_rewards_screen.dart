import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class LoyaltyRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) => _Presenter(myId: props.myId, loyaltyRewards: props.loyaltyRewards),
    );
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final List<Reward> loyaltyRewards;

  _Presenter({Key key, this.myId, this.loyaltyRewards}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String currentLayout = 'card';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[_appBar(), _content()],
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
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
            Text('MY LOYALTY REWARDS', style: Burnt.appBarTitleStyle),
            if (widget.loyaltyRewards != null && widget.loyaltyRewards.isNotEmpty) Text('All your loyalty rewards'),
          ],
        ),
      )),
    );
  }

  Widget _content() {
    if (widget.loyaltyRewards == null) return LoadingSliverCenter();
    if (widget.loyaltyRewards.isEmpty) return _noRewards();
    return RewardCards(rewards: widget.loyaltyRewards, confirmUnfavorite: true);
  }

  Widget _noRewards() {
    return CenterTextSliver(text: 'Looks like you haven\'t favourited any rewards yet.\nDon\'t miss out!');
  }
}

class _Props {
  final int myId;
  final List<Reward> loyaltyRewards;

  _Props({this.myId, this.loyaltyRewards});

  static fromStore(Store<AppState> store) {
    var me = store.state.me.user;
    var rewards = store.state.reward.rewards;
    var loyaltyRewards = store.state.reward.loyalty;
    return _Props(
      myId: me != null ? me.id : 0,
      loyaltyRewards: List<Reward>.from(Utils.subset(loyaltyRewards, rewards)),
    );
  }
}
