import 'dart:convert';

import 'package:crust/components/dialog/dialog.dart';
import 'package:crust/components/screens/privacy_screen.dart';
import 'package:crust/components/screens/register_screen.dart';
import 'package:crust/components/screens/terms_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/user.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/me/me_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:url_launcher/url_launcher.dart';

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

class _Presenter extends StatefulWidget {
  final Function loginSuccess;

  _Presenter({Key key, this.loginSuccess}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(loginSuccess: loginSuccess);
}

class _PresenterState extends State<_Presenter> {
  final Function loginSuccess;
  bool _loading = false;

  _PresenterState({this.loginSuccess});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          body: Container(
            decoration: BoxDecoration(gradient: Burnt.burntGradient),
            child: Builder(builder: (context) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _content(context),
              );
            }),
          ),
        ),
        if (_loading) LoadingOverlay(),
      ],
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
        _googleButton(context),
        Container(height: 15.0),
        _facebookButton(context),
        Container(height: 20.0),
        _terms(context),
      ],
    );
  }

  Widget _googleButton(context) {
    return WhiteButton(
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/login-google.png', height: 40.0),
            Container(width: 20.0),
            Text('Login with Google', style: TextStyle(fontSize: 25.0, color: Color(0xFFF7900A))),
            Container(width: 30.0),
          ],
        ),
        onPressed: () => _loginWithGoogle(context)
    );
  }

  Widget _facebookButton(context) {
    return WhiteButton(
        child: Row(
          children: <Widget>[
            Image.asset('assets/images/login-facebook.png', height: 40.0),
            Container(width: 20.0),
            Text('Login with Facebook', style: TextStyle(fontSize: 25.0, color: Color(0xFFF7900A))),
            Container(width: 10.0),
          ],
        ),
        onPressed: () => _loginWithFacebook(context)
    );
  }

  Widget _terms(context) {
    return Column(
      children: <Widget>[
        Text('By continuing you agree to our ', style: TextStyle(color: Colors.white)),
        Row(mainAxisSize: MainAxisSize.min, children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
            child: Text('Terms & Conditions', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
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

  _setError(message) {
    this.setState(() => _loading = false);

    var options = <DialogOption>[
      DialogOption(
        display: 'Email Us',
        onTap: () => launch(Utils.buildEmail(
            'Login Error', 'I couldn\'t login. (add-further-info-here-if-you-want)<br><br><br>$message')),
      )
    ];
    showDialog(
      context: context,
      builder: (context) {
        return BurntDialog(
          options: options,
          description: 'Oops, something went wrong.\nPlease email this so we can fix this stat!',
        );
      },
    );
  }

  _loginWithFacebook(context) async {
    this.setState(() => _loading = true);

    try {
      var login = FacebookLogin();
      var result = await login.logIn(['email']);
      if (result.status != FacebookLoginStatus.loggedIn) {
        await login.logOut();
        result = await login.logIn(['email']);
        if (result.status != FacebookLoginStatus.loggedIn) {
          _setError(result.errorMessage);
          return;
        }
      }
      var graphResponse = await http.get(
          'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture.height(200)&access_token=${result.accessToken.token}');
      var user = User.fromFacebook(result.accessToken.token, json.decode(graphResponse.body));
      await _login(user, context);
    } catch (e) {
      _setError(e.toString());
    }
  }

  _loginWithGoogle(context) async {
    this.setState(() => _loading = true);

    try {
      GoogleSignIn _googleSignIn = GoogleSignIn();
      GoogleSignInAccount googleUser = await _googleSignIn.signIn();
      await _login(User.fromGoogle(googleUser), context);
    } catch (e) {
      _setError(e.toString());
    }
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
