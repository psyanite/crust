import 'package:meta/meta.dart';

import 'package:crust/modules/auth/auth_state.dart';

@immutable
class AppState {
    final AuthState auth;

    AppState({AuthState auth}):
        auth = auth ?? new AuthState();

    static AppState rehydrateFromJson(dynamic json) => new AppState(
        auth: new AuthState.fromJSON(json['auth'])
    );

    Map<String, dynamic> toJson() => {
        'auth': auth.toJSON()
    };

    AppState copyWith({
        bool rehydrated,
        AuthState auth,
    }) {
        return new AppState(
            auth: auth ?? this.auth
        );
    }

    @override
    String toString() {
        return '''AppState{
            auth: $auth,
        }''';
    }
}