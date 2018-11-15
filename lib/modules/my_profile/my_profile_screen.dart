import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/settings/settings_screen.dart';
import 'package:crust/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => store.state.auth.user, builder: (context, user) => _Presenter(user: user));
  }
}

class _Presenter extends StatelessWidget {
  final User user;

  _Presenter({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: themeColors['white'],
        elevation: 0.0,
        actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SettingsScreen())),
        ),
      ]),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
          new Container(
              width: 190.0,
              height: 190.0,
              decoration: new BoxDecoration(
                  shape: BoxShape.circle, image: new DecorationImage(fit: BoxFit.fill, image: new NetworkImage(user.picture)))),
          new Text(user.fullName)
        ]),
      ),
    );
  }
}
