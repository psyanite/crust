import 'package:crust/models/reward.dart';

class UserReward {
  final Reward reward;
  final int rewardId;
  final String uniqueCode;
  final DateTime lastRedeemedAt;
  final int redeemedCount;

  UserReward({
    this.reward,
    this.rewardId,
    this.uniqueCode,
    this.lastRedeemedAt,
    this.redeemedCount,
  });

  bool isRedeemed(Reward reward) {
    switch (reward.type) {
      case RewardType.one_time:
        return lastRedeemedAt != null;

      case RewardType.unlimited:
      default:
        return false;
    }
  }

  factory UserReward.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserReward(
      reward: json['reward'] != null ? Reward.fromToaster(json['reward']) : null,
      rewardId: json['reward_id'],
      uniqueCode: json['unique_code'],
      lastRedeemedAt: json['last_redeemed_at'] != null ? DateTime.parse(json['last_redeemed_at']) : null,
      redeemedCount: json['redeemed_count'],
    );
  }

  static const attributes = """
    reward_id,
    unique_code,
    last_redeemed_at,
    redeemed_count,
  """;

  @override
  String toString() {
    return '{ rewardId: $rewardId, uniqueCode: $uniqueCode, redeemedAt: $lastRedeemedAt, count: $redeemedCount }';
  }
}
