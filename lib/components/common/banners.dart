import 'package:crust/presentation/components.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class MyBanner extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => store.state.me?.user?.profilePicture,
      builder: (context, image) {
        return BurntBanner(image: image);
      },
    );
  }
}

class BurntBanner extends StatelessWidget {
  final String image;

  BurntBanner({Key key, this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.bottomCenter,
      children: <Widget>[
        NetworkImg(image, height: 300.0),
        Container(
          height: 300.0,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [0, 0.8],
              colors: [Color(0x00000000), Color(0x60000000)],
            ),
          ),
        ),
      ],
    );
  }
}
