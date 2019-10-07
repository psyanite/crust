import 'package:crust/components/my_profile/my_profile_screen.dart';
import 'package:crust/components/screens/login_screen.dart';
import 'package:crust/models/user.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          user: props.user,
          refresh: props.refresh,
        );
      },
    );
  }
}


class _Presenter extends StatefulWidget {
  final User user;
  final Function refresh;

  _Presenter({Key key, this.user, this.refresh}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.user == null && old.user != widget.user) {
      widget.refresh();
    }
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    return widget.user == null ? LoginScreen() : MyProfileScreen();
  }
}

class _Props {
  final User user;
  final Function refresh;

  _Props({
    this.user,
    this.refresh,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      user: store.state.me.user,
      refresh: () => Utils.fetchUserData(store),
    );
  }
}
