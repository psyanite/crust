import 'dart:collection';

import 'package:crust/models/reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final LinkedHashMap<int, Reward> rewards;
  final LinkedHashMap<int, Reward> topRewards;

  RewardState({this.rewards, this.topRewards});

  RewardState.initialState()
    : rewards = LinkedHashMap<int, Reward>(),
      topRewards = LinkedHashMap<int, Reward>();

  RewardState copyWith({LinkedHashMap<int, Reward> rewards, LinkedHashMap<int, Reward> topRewards}) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      topRewards: topRewards ?? this.topRewards,
    );
  }

  RewardState addRewards(List<Reward> rewards) {
    var clone = cloneRewards();
    clone.addEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r)));
    return copyWith(rewards: clone);
  }

  RewardState addTopRewards(List<Reward> rewards) {
    rewards.shuffle();
    var clone = cloneTopRewards();
    clone.addEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r)));
    return copyWith(topRewards: clone);
  }

  RewardState addReward(Reward reward) {
    var clone = cloneRewards();
    clone[reward.id] = reward;
    return copyWith(rewards: clone);
  }

  LinkedHashMap<int, Reward> cloneRewards() {
    return LinkedHashMap<int, Reward>.from(this.rewards);
  }

  LinkedHashMap<int, Reward> cloneTopRewards() {
    return LinkedHashMap<int, Reward>.from(this.topRewards);
  }

  @override
  String toString() {
    return '''{
        rewards: ${rewards.length},
        topRewards: ${topRewards.length},
      }''';
  }
}
