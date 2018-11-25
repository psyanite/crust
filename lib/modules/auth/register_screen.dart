import 'package:crust/app/app_state.dart';
import 'package:crust/main.dart';
import 'package:crust/models/user.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:crust/modules/auth/data/me_service.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class RegisterScreen extends StatelessWidget {
  final User user;

  RegisterScreen({Key key, this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => (user) => store.dispatch(AddUserRequested(user)),
        builder: (context, addUser) => _Presenter(addUser: addUser, user: user));
  }
}

class _Presenter extends StatefulWidget {
  final Function addUser;
  final User user;

  _Presenter({Key key, this.addUser, this.user}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _username;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => Container(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 100.0, bottom: 20.0),
                    child: Text(
                      "What's your username?",
                      style: TextStyle(fontSize: 18.0),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: TextField(
                      decoration: new InputDecoration(hintText: "Username"),
                      onChanged: (val) => setState(() {
                            _username = val;
                          }),
                      style: TextStyle(fontSize: 18.0, color: Burnt.textBody),
                    ),
                  ),
                  SolidButton(text: "Next", onPressed: _press)
                ]),
          ),
    ));
  }

  _snack(context, text) {
    final snackBar = SnackBar(
      content: Text(text),
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
      ),
    );
    Scaffold.of(context).showSnackBar(snackBar);
  }

  _press(context) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (_username == null || _username.isEmpty) {
      _snack(context, 'Please enter at least 8 characters');
      return;
    }
    var userAccountId = await MeService.getUserAccountIdByUsername(_username);
    if (userAccountId != null) {
      _snack(context, 'Sorry, that username is already taken');
    } else {
      widget.addUser(widget.user.copyWith(username: _username));
      Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
    }
  }
}
