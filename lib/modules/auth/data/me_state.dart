import 'package:crust/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class MeState {
  final User user;

  MeState({
    this.user,
  });

  MeState copyWith({User user}) {
    return new MeState(
      user: user ?? this.user,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) => new MeState(
        user: json['user'] == null ? null : new User.rehydrate(json['user']),
      );

  Map<String, dynamic> toPersist() => <String, dynamic>{
        'user': this.user == null ? null : this.user.toPersist(),
      };

  @override
  String toString() {
    return '''{
        user: $user,
      }''';
  }
}
