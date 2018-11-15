import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/login_screen.dart';
import 'package:crust/modules/auth/register_screen.dart';
import 'package:crust/modules/my_profile/my_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {

    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => store.state.auth.user,
        builder: (context, user) => Scaffold(
              body: new Navigator(
                initialRoute: '/',
                onGenerateRoute: (routeSettings) {
                  switch (routeSettings.name) {
                    case '/':
                      return MaterialPageRoute(builder: (_) => user == null ? LoginScreen() : MyProfileScreen());
                    case '/register':
                      return MaterialPageRoute(builder: (_) => RegisterScreen());
                  }
                },
              ),
            ));
  }
}
