import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => (user) => store.dispatch(AddUserRequested(user)),
        builder: (context, addUser) => _Presenter(addUser: addUser));
  }
}

class _Presenter extends StatelessWidget {
  final Function addUser;

  _Presenter({Key key, this.addUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FlatButton(
              child: Text('Click'),
              onPressed: () {
                addUser(User(
                    fullName: "14241a24 420",
                    username: "124214a21",
                    picture: "4124a2421@fefefe.com",
                    socialId: "1241a42100",
                    type: UserType.facebook,
                    email: "fefeze@fefe.com"));
              }),
        ],
      )),
    );
  }
}
