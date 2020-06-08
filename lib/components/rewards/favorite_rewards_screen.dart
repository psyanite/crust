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

class FavoriteRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) => _Presenter(myId: props.myId, favoriteRewards: props.favoriteRewards),
    );
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final List<Reward> favoriteRewards;

  _Presenter({Key key, this.myId, this.favoriteRewards}) : super(key: key);

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
            Text('FAVOURITE REWARDS', style: Burnt.appBarTitleStyle),
            if (widget.favoriteRewards != null && widget.favoriteRewards.isNotEmpty) Text('All your favourited rewards'),
          ],
        ),
      )),
    );
  }

  Widget _content() {
    if (widget.favoriteRewards == null) return LoadingSliverCenter();
    if (widget.favoriteRewards.isEmpty) return _noRewards();
    return RewardCards(rewards: widget.favoriteRewards, confirmUnfavorite: true);
  }

  Widget _noRewards() {
    return CenterTextSliver(text: 'Looks like you haven\'t favourited any rewards yet.\nDon\'t miss out!');
  }
}

class _Props {
  final int myId;
  final List<Reward> favoriteRewards;

  _Props({this.myId, this.favoriteRewards});

  static fromStore(Store<AppState> store) {
    var me = store.state.me.user;
    var rewards = store.state.reward.rewards;
    var favoriteRewards = store.state.favorite.rewards;
    return _Props(
      myId: me != null ? me.id : 0,
      favoriteRewards: List<Reward>.from(Utils.subset(favoriteRewards, rewards)),
    );
  }
}
