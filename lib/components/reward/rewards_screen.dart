import 'package:crust/components/reward/reward_cards.dart';
import 'package:crust/components/reward/reward_list.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RewardsScreen extends StatefulWidget {
  @override
  RewardsScreenState createState() => RewardsScreenState();
}

class RewardsScreenState extends State<RewardsScreen> {
  _LayoutType _currentLayout = _LayoutType.card;

  void _toggleLayout() {
    setState(() {
      if (_currentLayout == _LayoutType.card) {
        _currentLayout = _LayoutType.list;
      } else {
        _currentLayout = _LayoutType.card;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<Reward>>(
        onInit: (Store<AppState> store) => store.dispatch(FetchRewardsRequested()),
        converter: (Store<AppState> store) => store.state.reward.rewards,
        builder: (BuildContext context, List<Reward> rewards) =>
            CustomScrollView(slivers: <Widget>[_appBar(), _filters(), _content(rewards)]));
  }

  Widget _appBar() {
    return SliverAppBar(
        pinned: false,
        floating: false,
        expandedHeight: 60.0,
        backgroundColor: Burnt.primary,
        elevation: 24.0,
        title: Text('Rewards', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _filters() {
    return SliverToBoxAdapter(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          IconButton(
            splashColor: Colors.transparent,
              padding: EdgeInsets.all(0.0), icon: Icon(Icons.autorenew), color: Burnt.primary, iconSize: 20.0, onPressed: _toggleLayout),
        ],
      ),
    );
  }

  Widget _content(List<Reward> rewards) {
    if (rewards == null) return LoadingSliver();
    if (_currentLayout == _LayoutType.card) {
      return RewardCards(rewards: rewards);
    }
    return RewardList(rewards: rewards);
  }
}

enum _LayoutType { card, list }
