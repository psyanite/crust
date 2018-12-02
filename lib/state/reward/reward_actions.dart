import 'package:crust/models/reward.dart';

class FetchRewardsRequested {}

class FetchRewardsSuccess {
  final List<Reward> rewards;

  FetchRewardsSuccess(this.rewards);
}
