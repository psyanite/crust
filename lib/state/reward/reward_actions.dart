import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';

class FetchRedeemedRewards {}

class FetchRewardsNearMeSuccess {
  final List<Reward> rewards;

  FetchRewardsNearMeSuccess(this.rewards);
}

class ClearNearMe {}

class FetchRewardsSuccess {
  final List<Reward> rewards;

  FetchRewardsSuccess(this.rewards);
}

class FetchRewardSuccess {
  final Reward reward;

  FetchRewardSuccess(this.reward);
}

class FetchTopRewards {}

class FetchTopRewardsSuccess {
  final List<Reward> rewards;

  FetchTopRewardsSuccess(this.rewards);
}

class FetchUserRewardsSuccess {
  final List<UserReward> userRewards;

  FetchUserRewardsSuccess(this.userRewards);
}
