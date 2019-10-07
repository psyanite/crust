import 'dart:collection';

import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final LinkedHashMap<int, Reward> rewards;
  final LinkedHashMap<int, Reward> topRewards;
  final Set<int> nearMe;
  final Set<int> loyalty;
  final List<UserReward> redeemed;

  RewardState({this.rewards, this.topRewards, this.nearMe, this.loyalty, this.redeemed});

  RewardState.initialState()
    : rewards = LinkedHashMap<int, Reward>(),
      topRewards = LinkedHashMap<int, Reward>(),
      nearMe = Set<int>(),
      loyalty = Set<int>(),
      redeemed = List<UserReward>();

  RewardState copyWith({LinkedHashMap<int, Reward> rewards, LinkedHashMap<int, Reward> topRewards, Set<int> nearMe, Set<int> loyalty, List<UserReward> redeemed}) {
    return RewardState(
      rewards: rewards ?? this.rewards,
      topRewards: topRewards ?? this.topRewards,
      nearMe: nearMe ?? this.nearMe,
      loyalty: loyalty ?? this.loyalty,
      redeemed: redeemed ?? this.redeemed,
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

  RewardState addNearMe(List<Reward> rewards) {
    var rewardIds = rewards.map((r) => r.id);
    return addRewards(rewards).copyWith(nearMe: cloneNearMe()..addAll(rewardIds));
  }

  RewardState setRedeemed(List<UserReward> userRewards) {
    return copyWith(redeemed: userRewards);
  }

  RewardState addLoyalty(List<Reward> rewards) {
    var rewardIds = rewards.map((r) => r.id).toSet();
    return addRewards(rewards).copyWith(loyalty: rewardIds);
  }

  LinkedHashMap<int, Reward> cloneRewards() {
    return LinkedHashMap<int, Reward>.from(this.rewards);
  }

  LinkedHashMap<int, Reward> cloneTopRewards() {
    return LinkedHashMap<int, Reward>.from(this.topRewards);
  }

  Set<int> cloneNearMe() {
    return Set<int>.from(this.nearMe);
  }

  @override
  String toString() {
    return '''{ rewards: ${rewards.length}, topRewards: ${topRewards.length}, loyalty: ${loyalty.length}, nearMe: ${nearMe.join(',')} }''';
  }
}
