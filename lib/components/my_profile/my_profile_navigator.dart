import 'package:crust/components/my_profile/my_profile_screen.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/components/screens/login_screen.dart';
import 'package:crust/components/screens/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => store.state.me.user,
        builder: (context, user) => Scaffold(
              body: Navigator(
                initialRoute: '/',
                onGenerateRoute: (routeSettings) {
                  switch (routeSettings.name) {
                    case '/register':
                      return MaterialPageRoute(builder: (_) => RegisterScreen());
                    default:
                      return MaterialPageRoute(builder: (_) => user == null ? LoginScreen() : MyProfileScreen());
                  }
                },
              ),
            ));
  }
}
