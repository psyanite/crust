import 'package:redux_persist/redux_persist.dart';

import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_reducer.dart';
import 'package:crust/modules/home/home_reducer.dart';

AppState appReducer(AppState state, action) {

  if (action is PersistLoadedAction<AppState>) {
    return action.state ?? state;
  } else {
    return new AppState(
      auth: authReducer(state.auth, action),
      home: homeReducer(state.home, action)
    );
  }
}
