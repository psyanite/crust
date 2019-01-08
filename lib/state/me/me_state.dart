import 'package:crust/models/user.dart';
import 'package:crust/models/user_reward.dart';
import 'package:meta/meta.dart';

@immutable
class MeState {
  final User user;
  final Set<int> favoriteRewards;
  final Set<int> favoriteStores;
  final UserReward userReward;

  MeState({
    this.user,
    this.favoriteRewards,
    this.favoriteStores,
    this.userReward,
  });

  MeState copyWith({User user, Set<int> favoriteRewards, Set<int> favoriteStores, UserReward userReward}) {
    return MeState(
      user: user ?? this.user,
      favoriteRewards: favoriteRewards ?? this.favoriteRewards,
      favoriteStores: favoriteStores ?? this.favoriteStores,
      userReward: userReward ?? this.userReward,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) => new MeState(
        user: json['user'] != null ? new User.rehydrate(json['user']) : null,
      );

  Map<String, dynamic> toPersist() => <String, dynamic>{
        'user': this.user != null ? this.user.toPersist() : null,
      };

  @override
  String toString() {
    return '''{
        user: $user,
        favoriteRewards: ${favoriteRewards != null ? '${favoriteRewards.length} rewards' : null},
        favoriteStores: ${favoriteStores != null ? '${favoriteStores.length} stores' : null},
        userReward: $userReward,
      }''';
  }
}
