import 'package:crust/modules/auth/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class AuthState {
  final User user;

  AuthState({
    this.user,
  });

  AuthState copyWith({User user}) {
    return new AuthState(
      user: user ?? this.user,
    );
  }

  factory AuthState.fromJSON(Map<String, dynamic> json) => new AuthState(
        user: json['user'] == null ? null : new User.fromJSON(json['user']),
      );

  Map<String, dynamic> toJSON() => <String, dynamic>{
        'user': this.user == null ? null : this.user.toJSON(),
      };

  @override
  String toString() {
    return '''{
                user: $user,
            }''';
  }
}
