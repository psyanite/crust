import 'package:crust/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class MeState {
  final User user;
  final Set<int> favoriteRewards;
  final Set<int> favoriteStores;

  MeState({
    this.user,
    this.favoriteRewards,
    this.favoriteStores,
  });

  MeState copyWith({User user, Set<int> favoriteRewards, Set<int> favoriteStores}) {
    return MeState(
      user: user ?? this.user,
      favoriteRewards: favoriteRewards ?? this.favoriteRewards,
      favoriteStores: favoriteStores ?? this.favoriteStores,
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
      }''';
  }
}
