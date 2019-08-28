import 'package:crust/models/reward.dart';

class FetchRewardsNearMe {
  final int limit;
  final int offset;

  FetchRewardsNearMe(this.limit, this.offset);
}

class FetchRewardsNearMeSuccess {
  final List<int> rewardIds;

  FetchRewardsNearMeSuccess(this.rewardIds);
}

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
