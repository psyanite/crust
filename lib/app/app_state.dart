import 'package:crust/modules/auth/data/auth_state.dart';
import 'package:crust/modules/error/error_state.dart';
import 'package:crust/modules/home/home_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final AuthState auth;
  final HomeState home;
  final ErrorState error;

  AppState({AuthState auth, HomeState home, ErrorState error})
      : auth = auth ?? new AuthState(),
        home = home ?? new HomeState(),
        error = error ?? new ErrorState();

  static AppState rehydrateFromJson(dynamic json) => new AppState(
    auth: json['auth'] == null ? null : new AuthState.fromJson(json['auth'])
  );

  Map<String, dynamic> toJson() => {'auth': auth.toJson()};

  AppState copyWith({
    bool rehydrated,
    AuthState auth,
  }) {
    return new AppState(auth: auth ?? this.auth);
  }

  @override
  String toString() {
    return '''
      AppState{
        auth: $auth,
        home: $home,
        error: $error
      }
    ''';
  }
}
