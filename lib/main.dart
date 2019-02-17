import 'package:crust/components/main_tab_navigator.dart';
import 'package:crust/components/screens/splash_screen.dart';
import 'package:crust/presentation/platform_adaptive.dart';
import 'package:crust/state/app/app_middleware.dart';
import 'package:crust/state/app/app_reducer.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_logging/redux_logging.dart';
import 'package:redux_persist/redux_persist.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() async {
  final persistor = Persistor<AppState>(storage: FlutterStorage(), serializer: JsonSerializer<AppState>(AppState.rehydrate));

  var initialState;
  try {
    initialState = await persistor.load();
  } catch (e) {
    initialState = null;
  }

  List<Middleware<AppState>> createMiddleware() {
    return <Middleware<AppState>>[
      thunkMiddleware,
      persistor.createMiddleware(),
      LoggingMiddleware.printer(),
    ]..addAll(createAppMiddleware());
  }

  final store = Store<AppState>(
    appReducer,
    initialState: initialState ?? AppState(),
    middleware: createMiddleware(),
  );

  runApp(Main(store: store));
}

class MainRoutes {
  static const String root = '/';
  static const String splash = '/splash';
}

class Main extends StatelessWidget {
  final store;

  Main({this.store});

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
          title: 'Burntoast',
          color: Color(0xFFF2993E),
          theme: getTheme(context),
          initialRoute: MainRoutes.splash,
          routes: <String, WidgetBuilder>{
            MainRoutes.splash: (context) => SplashScreen(),
            MainRoutes.root: (context) => MainTabNavigator(),
          }),
    );
  }
}
