import 'dart:convert';

import 'package:crust/components/screens/privacy_screen.dart';
import 'package:crust/components/screens/register_screen.dart';
import 'package:crust/components/screens/terms_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:flutter/cupertino.dart';
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
      converter: (Store<AppState> store) => (user) {
        store.dispatch(LoginSuccess(user));
        store.dispatch(CheckFcmToken());
      },
      builder: (context, loginSuccess) => _Presenter(loginSuccess: loginSuccess),
    );
  }
}

class _Presenter extends StatelessWidget {
  final Function loginSuccess;

  _Presenter({Key key, this.loginSuccess}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: Burnt.burntGradient),
        child: Builder(builder: (context) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: _content(context),
          );
        }),
      ),
    );
  }

  Widget _content(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Image.asset('assets/images/loading-icon.png', height: 200.0),
        Container(height: 15.0),
        WhiteButton(text: 'Login with Facebook', onPressed: () => _loginWithFacebook(context)),
        Container(height: 15.0),
        WhiteButton(text: 'Login with Google', onPressed: () => _loginWithGoogle(context)),
        Container(height: 15.0),
        WhiteButton(text: 'Login with Data Profile', onPressed: () => _loginWithDataProfile(context)),
        Container(height: 15.0),
        WhiteButton(text: 'Login with Empty Profile', onPressed: () => _loginWithEmptyProfile(context)),
        Container(height: 20.0),
        _terms(context),
      ],
    );
  }

  Widget _terms(context) {
    return Column(
      children: <Widget>[
        Text('By continuing you agree to our ', style: TextStyle(color: Colors.white)),
        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
            child: Text('Terms of Use', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
          ),
          Text(' and ', style: TextStyle(color: Colors.white)),
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyScreen())),
            child: Text('Privacy Policy', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
          ),
          Text('.', style: TextStyle(color: Colors.white))
        ])
      ],
    );
  }

  _loginWithFacebook(context) async {
    var login = FacebookLogin();
    var result = await login.logIn(['email']);
    if (result.status != FacebookLoginStatus.loggedIn) {
      await login.logOut();
      result = await login.logIn(['email']);
      if (result.status != FacebookLoginStatus.loggedIn) {
        return;
      }
    }
    var graphResponse = await http.get(
        'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');
    var user = User.fromFacebook(result.accessToken.token, json.decode(graphResponse.body));
    await _login(user, context);
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

  _loginWithDataProfile(context) async {
    var user = User(
      firstName: 'Neila',
      lastName: 'Nyan',
      displayName: 'Neila Nyan',
      email: 'psyneia@gmail.com',
      profilePicture: 'meow',
      socialType: SocialType.facebook,
      socialId: '1905457732907903',
      token:
          'EAAdWJ8R7ISsBAOZCfBqwJQmxbNV6cpgZCp8DBjTuufciDUqIvzJxLq5ZBaecbPyKUq5SRgJrpWWKJY5fQd72GfV0cVuTDk84cAZBlSb00pZBTBQULk2ybauUsqeL3sa9NBMM3GuBrqX5KcZCFo8ovZC0xuiZCFGo9ZAH5gSRTuKugrIkw0q8p1e53RHZBbFqzFUQ3o9cZCjSgNtCQZDZD',
    );
    await _login(user, context);
  }

  _loginWithEmptyProfile(context) async {
    var user = User(
      firstName: 'Sophia',
      lastName: 'King',
      displayName: 'Sophia',
      email: 'sophia_king@gmail.com',
      profilePicture: 'meow',
      socialType: SocialType.google,
      socialId: 'sophia123',
      token:
          'EAAdWJ8R7ISsBAOZCfBqwJQmxbNV6cpgZCp8DBjTuufciDUqIvzJxLq5ZBaecbPyKUq5SRgJrpWWKJY5fQd72GfV0cVuTDk84cAZBlSb00pZBTBQULk2ybauUsqeL3sa9NBMM3GuBrqX5KcZCFo8ovZC0xuiZCFGo9ZAH5gSRTuKugrIkw0q8p1e53RHZBbFqzFUQ3o9cZCjSgNtCQZDZD',
    );
    await _login(user, context);
  }

  _login(user, context) async {
    var fetchedUser = await MeService.getUser(user);
    if (fetchedUser != null) {
      loginSuccess(fetchedUser);
      Navigator.popUntil(context, ModalRoute.withName(MainRoutes.home));
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen(user: user)));
    }
  }
}
