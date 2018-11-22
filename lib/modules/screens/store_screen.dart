import 'package:crust/app/app_state.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:redux_persist_flutter/redux_persist_flutter.dart';

class StoreScreen extends StatelessWidget {
  final int storeId;

  StoreScreen({Key key, this.storeId}) : super(key: key);

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
                var storage = new FlutterStorage('meow');
                var storage2 = new FlutterStorage('redux-app');
                storage.save("{\"version\":-1,\"state\":{\"auth\":null}}");
                storage2.save("{\"version\":-1,\"state\":{\"auth\":null}}");
              }),
        ],
      )),
    );
  }
}
