import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
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
      body: Center(child: Text('New Post')),
    );
  }
}
