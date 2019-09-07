import 'package:crust/models/reward.dart';

class FetchRewardsNearMe {
  final double lat;
  final double lng;
  final int limit;
  final int offset;

  FetchRewardsNearMe(this.lat, this.lng, this.limit, this.offset);

  @override
  String toString() => '$lat $lng, limit: $limit, offset: $offset';
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

class SetNearMeAll {
  final bool nearMeAll;

  SetNearMeAll(this.nearMeAll);
}

class ClearNearMe {}
