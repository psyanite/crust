import 'dart:collection';

import 'package:crust/models/reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final LinkedHashMap<int, Reward> rewards;

  RewardState({this.rewards});

  RewardState copyWith({List<Reward> rewards}) {
    var rewardsUpdate = this.rewards ?? LinkedHashMap<int, Reward>();
    if (rewards != null) {
      rewardsUpdate.addAll(Map.fromEntries(rewards.map((s) => MapEntry<int, Reward>(s.id, s))));
    }
    return RewardState(
      rewards: rewardsUpdate,
    );
  }
}
