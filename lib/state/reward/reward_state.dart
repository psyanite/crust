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
    var clone = cloneRewards();
    clone.addAll(Map.fromEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r))));
    return RewardState(rewards: clone);
  }

  RewardState addReward(Reward reward) {
    var clone = cloneRewards();
    clone[reward.id] = reward;
    return RewardState(rewards: clone);
  }

  LinkedHashMap<int, Reward> cloneRewards() {
    return this.rewards != null ? LinkedHashMap<int, Reward>.from(this.rewards) : LinkedHashMap<int, Reward>();
  }

  @override
  String toString() {
    return '''{
        rewards: ${rewards != null ? '${rewards.length} rewards' : null},
      }''';
  }
}
