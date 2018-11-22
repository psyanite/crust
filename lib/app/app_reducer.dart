import 'package:redux_persist/redux_persist.dart';

import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_reducer.dart';
import 'package:crust/modules/home/home_reducer.dart';
import 'package:crust/modules/error/error_reducer.dart';

AppState appReducer(AppState state, action) {

  if (action is PersistLoadedAction<AppState>) {
    return action.state ?? state;
  } else {
    return new AppState(
      me: authReducer(state.me, action),
      home: homeReducer(state.home, action),
      error: errorReducer(state.error, action)
    );
  }
}
