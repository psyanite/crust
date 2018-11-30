import 'package:crust/state/me/me_state.dart';
import 'package:crust/state/error/error_state.dart';
import 'package:crust/state/home/home_state.dart';
import 'package:crust/state/user/user_state.dart';
import 'package:meta/meta.dart';

@immutable
class AppState {
  final MeState me;
  final HomeState home;
  final UserState user;
  final ErrorState error;

  AppState({MeState me, HomeState home, UserState user, ErrorState error})
      : me = me ?? new MeState(),
        home = home ?? new HomeState(),
        user = user ?? new UserState(),
        error = error ?? new ErrorState();

  static AppState rehydrate(dynamic json) {
    try {
      return AppState(
        me: json['me'] == null ? null : new MeState.rehydrate(json['me'])
      );
    }
    catch (e) {
      print("Could not deserialize json from persistor: $e");
      return AppState();
    }
  }

  // Used by persistor
  Map<String, dynamic> toJson() => {'me': me.toPersist()};

  AppState copyWith({MeState me}) {
    return AppState(me: me ?? this.me);
  }

  @override
  String toString() {
    return '''{
      me: $me,
      home: $home,
      user: $user,
      error: $error
    }''';
  }
}
