import 'dart:convert';

import 'package:crust/app/app_state.dart';
import 'package:crust/main.dart';
import 'package:crust/modules/auth/data/me_actions.dart';
import 'package:crust/modules/auth/data/me_service.dart';
import 'package:crust/models/user.dart';
import 'package:crust/modules/auth/register_screen.dart';
import 'package:crust/presentation/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
        converter: (Store<AppState> store) => (user) => store.dispatch(LoginSuccess(user)),
        builder: (context, loginSuccess) => _Presenter(loginSuccess: loginSuccess));
  }
}

class _Presenter extends StatelessWidget {
  final Function loginSuccess;

  _Presenter({Key key, this.loginSuccess}) : super(key: key);

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Container(
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
                Image.asset('assets/images/loading-icon.png', height: 250.0),
                WhiteButton(text: "Login with Facebook", onPressed: _loginWithFacebook),
                Container(height: 10.0),
                WhiteButton(text: "Login with Google", onPressed: _loginWithGoogle),
              ]),
        ),
      );
    }

  _loginWithFacebook(context) async {
    var result = await FacebookLogin().logInWithReadPermissions(['email']);
    if (result.status == FacebookLoginStatus.loggedIn) {
      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');
      var user = User.fromFacebook(result.accessToken.token, json.decode(graphResponse.body));
      await _login(user, context);
    }
  }

  _loginWithGoogle(context) async {
    GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[
        'email',
        'https://www.googleapis.com/auth/contacts.readonly',
      ],
    );
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    await _login(User.fromGoogle(googleUser), context);
  }

  _login(user, context) async {
    var fetchedUser = await MeService.getUser(user);
    if (fetchedUser != null) {
      loginSuccess(fetchedUser);
      Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => RegisterScreen(user: user)),
      );
    }
  }
}
