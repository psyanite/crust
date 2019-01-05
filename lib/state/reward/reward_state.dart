import 'dart:collection';

import 'package:crust/models/reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final LinkedHashMap<int, Reward> rewards;

  RewardState({this.rewards});

  RewardState copyWith({LinkedHashMap<int, Reward> rewards}) {
    return RewardState(
      rewards: rewards ?? this.rewards,
    );
  }

  RewardState addRewards(List<Reward> rewards) {
    var rewardsUpdate = this.rewards ?? LinkedHashMap<int, Reward>();
    if (rewards != null) {
      rewardsUpdate.addAll(Map.fromEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r))));
    }
    return RewardState(
      rewards: rewardsUpdate,
    );
  }

  @override
  String toString() {
    return '''{
        rewards: ${rewards != null ? '${rewards.length} rewards' : null},
      }''';
  }
}
