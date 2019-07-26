import 'package:crust/models/reward.dart';

class UserReward {
  final Reward reward;
  final String uniqueCode;
  final DateTime redeemedAt;

  UserReward({
    this.reward,
    this.uniqueCode,
    this.redeemedAt,
  });

  bool isRedeemed() {
    return redeemedAt != null;
  }

  bool isExpired() {
    return reward.isExpired();
  }

  factory UserReward.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserReward(
      reward: Reward.fromToaster(json['reward']),
      uniqueCode: json['unique_code'],
      redeemedAt: json['redeemed_at'] != null ? DateTime.parse(json['redeemed_at']) : null,
    );
  }

  @override
  String toString() {
    return '{ reward: $reward.id, uniqueCode: $uniqueCode, redeemedAt: $redeemedAt }';
  }
}
