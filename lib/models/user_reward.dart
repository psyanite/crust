import 'package:crust/models/reward.dart';

class UserReward {
  final Reward reward;
  final String uniqueCode;
  final bool isRedeemed;

  UserReward({
    this.reward,
    this.uniqueCode,
    this.isRedeemed,
  });

  factory UserReward.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return UserReward(
      reward: Reward.fromToaster(json['reward']),
      uniqueCode: json['unique_code'],
      isRedeemed: json['is_redeemed'],
    );
  }

  @override
  String toString() {
    return '{ reward: $reward.id, uniqueCode: $uniqueCode, isRedeemed: $isRedeemed }';
  }
}
