import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class NewPostScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => (user) => store.dispatch(AddUserRequest(user)),
        builder: (context, addUser) => _Presenter(addUser: addUser));
  }
}

class _Presenter extends StatelessWidget {
  final Function addUser;

  _Presenter({Key key, this.addUser}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _content());
  }

  Widget _appBar() {
    return AppBar(
      automaticallyImplyLeading: true,
      backgroundColor: Burnt.primary,
      elevation: 0.0,
      title: Text('Post', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _content() {
    return Center(
      child: Text('Coming soon!'),
    );
  }
}
