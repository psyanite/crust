import 'package:crust/models/reward.dart';

class FetchRewardsNearMeSuccess {
  final List<Reward> rewards;

  FetchRewardsNearMeSuccess(this.rewards);
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

class ClearNearMe {}
