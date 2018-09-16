import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:crust/modules/app/app_state.dart';
import 'package:crust/presentation/platform_adaptive.dart';
import 'package:crust/modules/loading/loading_screen.dart';
import 'package:crust/modules/auth/login_screen.dart';
import 'package:crust/modules/main/main_tab_navigator.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:crust/modules/app/app_reducer.dart';

void main() => runApp(new Main());

class Main extends StatelessWidget {
    final store = createStore();

    Main();

    @override
    Widget build(BuildContext context) {
        return new PersistorGate(
            persistor: persistor,
            loading: new LoadingScreen(),
            builder: (context) => new StoreProvider<AppState>(
                store: store,
                child: new MaterialApp(
                    title: 'ReduxApp',
                    theme: defaultTargetPlatform == TargetPlatform.iOS
                        ? kIOSTheme
                        : kDefaultTheme,
                    routes: <String, WidgetBuilder>{
                        '/': (BuildContext context) => new MainTabNavigator(),
                        '/login': (BuildContext context) => new LoginScreen()
                    }
                )
            ),
        );
    }

}

Store<AppState> createStore() {
  Store<AppState> store = new Store(
    appReducer,
    initialState: new AppState(),
    middleware: createMiddleware(),
  );
  persistor.start(store);

  return store;
}

final persistor = new Persistor<AppState>(storage: new FlutterStorage('redux-app'), decoder: AppState.rehydrationJSON);

List<Middleware<AppState>> createMiddleware() => <Middleware<AppState>>[
  thunkMiddleware,
  persistor.createMiddleware(),
  new LoggingMiddleware.printer(),
];