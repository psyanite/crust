import 'package:crust/components/rewards/reward_cards.dart';
import 'package:crust/components/rewards/view_mode_icon.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MoreRewardsScreen extends StatelessWidget {
  final String title;
  final String description;
  final List<Reward> rewards;

  MoreRewardsScreen({Key key, this.title, this.description, this.rewards}) : super(key: key);

  // TODO: is this required?
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (context, props) => _Presenter(
              myId: props.myId,
              title: title,
              description: description,
              rewards: rewards,
            ));
  }
}

class _Presenter extends StatefulWidget {
  final int myId;
  final String title;
  final String description;
  final List<Reward> rewards;

  _Presenter({Key key, this.myId, this.title, this.description, this.rewards}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String currentLayout = 'card';

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), _rewardsListTitle(), _rewardsList()];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
              ],
            ),
            Text(widget.title.toUpperCase(), style: Burnt.appBarTitleStyle)
          ],
        ),
      )),
    );
  }

  Widget _rewardsListTitle() {
    return SliverToBoxAdapter(
        child: Container(
            padding: EdgeInsets.only(bottom: 10.0, left: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(widget.description),
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
            )));
  }

  Widget _rewardsList() {
    if (widget.rewards == null) return LoadingSliverCenter();
    return RewardCards(rewards: widget.rewards, layout: currentLayout);
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
