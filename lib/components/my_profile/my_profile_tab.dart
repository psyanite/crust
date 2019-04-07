import 'package:crust/components/my_profile/my_profile_screen.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/models/user.dart';
import 'package:crust/components/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileTab extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => store.state.me.user, builder: (context, user) => Presenter(user: user));
  }
}

class Presenter extends StatelessWidget {
  final User user;

  Presenter({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return user == null ? LoginScreen() : MyProfileScreen();
  }
}
