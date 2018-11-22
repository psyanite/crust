import 'package:crust/app/app_reducer.dart';
import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_middleware.dart';
import 'package:crust/modules/home/home_middleware.dart';
import 'package:crust/modules/screens/loading_screen.dart';
import 'package:crust/modules/main/main_tab_navigator.dart';
import 'package:crust/presentation/platform_adaptive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() => runApp(new Main());

class MainRoutes {
  static const String root = '/';
}

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
          child: new MaterialApp(title: 'Crust', theme: getTheme(context), routes: <String, WidgetBuilder>{
            MainRoutes.root: (context) => new MainTabNavigator(),
          })),
    );
  }
}

final persistor = new Persistor<AppState>(storage: FlutterStorage('burntoast'), decoder: AppState.rehydrate);

List<Middleware<AppState>> createMiddleware() {
  return <Middleware<AppState>>[
    thunkMiddleware,
    persistor.createMiddleware(),
    new LoggingMiddleware.printer(),
  ]
    ..addAll(createHomeMiddleware())
    ..addAll(createMeMiddleware());
}

Store<AppState> createStore() {
  Store<AppState> store = new Store(
    appReducer,
    initialState: new AppState(),
    middleware: createMiddleware(),
  );
  persistor.load(store);
  return store;
}
