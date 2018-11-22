import 'package:crust/app/app_state.dart';
import 'package:crust/main.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => () => store.dispatch(Logout()), builder: (context, logout) => _Presenter(logout: logout));
  }
}

class _Presenter extends StatelessWidget {
  final Function logout;

  _Presenter({Key key, this.logout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          RaisedButton(
            child: Text('Logout'),
            onPressed: () {
              logout();
              Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
            },
          )
        ]),
      ),
    );
  }
}
