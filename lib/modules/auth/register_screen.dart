import 'package:crust/app/app_state.dart';
import 'package:crust/main.dart';
import 'package:crust/modules/auth/data/auth_actions.dart';
import 'package:crust/modules/auth/data/auth_repository.dart';
import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/presentation/colors.dart';
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0, 0.6, 1.0],
                colors: [
                  Color(0xFFffc86b),
                  Color(0xFFffab40),
                  Color(0xFFc45d35),
                ],
              ),
            ),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  FlatButton(
                    child: Text('Click'),
                    onPressed: () {
                      widget.addUser(User(
                          fullName: "14241a24 420",
                          username: "124214a21",
                          picture: "4124a2421@fefefe.com",
                          socialId: "1241a42100",
                          type: UserType.facebook,
                          email: "fefeze@fefe.com"));
                    },
                  ),
                  TextField(
                    decoration: new InputDecoration(labelText: "Username"),
                    onChanged: (val) => setState(() {
                          _username = val;
                        }),
                  ),
                  FlatButton(
                    textColor: ThemeColors.primaryDark,
                    color: ThemeColors.background,
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Text("Submit", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w100)),
                    onPressed: () => _press(context),
                  )
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
    if (_username == null || _username.isEmpty) {
      _snack(context, 'Please enter at least 8 characters');
      return;
    }
    var userAccountId = await AuthRepository.getUserAccountIdByUsername(_username);
    if (userAccountId != null) {
      _snack(context, 'Sorry, that username is already taken');
    } else {
      widget.addUser(widget.user.copyWith(username: _username));
      Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
    }
  }
}
