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
