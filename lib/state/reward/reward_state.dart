import 'dart:collection';

import 'package:crust/models/reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final LinkedHashMap<int, Reward> rewards;
  final LinkedHashMap<int, Reward> topRewards;
  final List<int> nearMe;
  final bool nearMeAll;

  RewardState({this.rewards, this.topRewards, this.nearMe, this.nearMeAll});

  RewardState.initialState()
    : rewards = LinkedHashMap<int, Reward>(),
      topRewards = LinkedHashMap<int, Reward>(),
      nearMe = List<int>(),
      nearMeAll = false;

  RewardState copyWith({LinkedHashMap<int, Reward> rewards, LinkedHashMap<int, Reward> topRewards, List<int> nearMe, bool nearMeAll}) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      topRewards: topRewards ?? this.topRewards,
      nearMe: nearMe ?? this.nearMe,
      nearMeAll: nearMeAll ?? this.nearMeAll,
    );
  }

  RewardState addRewards(List<Reward> rewards) {
    return copyWith(rewards: cloneRewards()..addEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r))));
  }

  RewardState setTopRewards(List<Reward> rewards) {
    rewards.shuffle();
    return copyWith(topRewards: LinkedHashMap<int, Reward>.fromEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r))));
  }

  RewardState addTopRewards(List<Reward> rewards) {
    rewards.shuffle();
    return copyWith(topRewards: cloneTopRewards()..addEntries(rewards.map((r) => MapEntry<int, Reward>(r.id, r))));
  }

  RewardState addReward(Reward reward) {
    var clone = cloneRewards();
    clone[reward.id] = reward;
    return copyWith(rewards: clone);
  }

  RewardState addNearMe(List<int> rewardIds) {
    return copyWith(nearMe: cloneNearMe()..addAll(rewardIds));
  }

  LinkedHashMap<int, Reward> cloneRewards() {
    return LinkedHashMap<int, Reward>.from(this.rewards);
  }

  LinkedHashMap<int, Reward> cloneTopRewards() {
    return LinkedHashMap<int, Reward>.from(this.topRewards);
  }

  List<int> cloneNearMe() {
    return List<int>.from(this.nearMe);
  }

  @override
  String toString() {
    return '''{ rewards: ${rewards.length}, topRewards: ${topRewards.length}, nearMe: ${nearMe.join(",")} }''';
  }
}
