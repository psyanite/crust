import 'package:crust/modules/auth/data/auth_state.dart';
import 'package:crust/modules/home/home_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final AuthState auth;
  final HomeState home;

  AppState({AuthState auth, HomeState home})
      : auth = auth ?? new AuthState(),
        home = home ?? new HomeState();

  static AppState rehydrateFromJson(dynamic json) =>
      new AppState(auth: new AuthState.fromJSON(json['auth']));

  Map<String, dynamic> toJson() => {'auth': auth.toJSON()};

  AppState copyWith({
    bool rehydrated,
    AuthState auth,
  }) {
    return new AppState(auth: auth ?? this.auth, home: home ?? this.home);
  }

  @override
  String toString() {
    return '''
      AppState{
        auth: $auth,
        home: $home
      }
    ''';
  }
}
