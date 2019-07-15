import 'package:crust/models/reward.dart';

class FetchRewardsRequest {}

class FetchRewardsSuccess {
  final List<Reward> rewards;

  FetchRewardsSuccess(this.rewards);
}
