import 'package:crust/models/reward.dart';
import 'package:meta/meta.dart';

@immutable
class RewardState {
  final List<Reward> rewards;

  RewardState({this.rewards});

  RewardState copyWith({List<Reward> rewards}) {
    return new RewardState(
      rewards: rewards ?? this.rewards,
    );
  }
}
