import 'package:crust/models/reward.dart';

class FetchRewards {}

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
