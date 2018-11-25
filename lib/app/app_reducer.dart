import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_reducer.dart';
import 'package:crust/modules/home/home_reducer.dart';
import 'package:crust/modules/error/error_reducer.dart';

AppState appReducer(AppState state, action) {
  return new AppState(
    me: authReducer(state.me, action),
    home: homeReducer(state.home, action),
    error: errorReducer(state.error, action)
  );
}
