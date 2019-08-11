import 'package:crust/components/my_profile/set_display_name_screen.dart';
import 'package:crust/components/my_profile/set_picture_screen.dart';
import 'package:crust/components/my_profile/set_tagline_screen.dart';
import 'package:crust/components/my_profile/set_username_screen.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  UpdateProfileScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _options(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
                ],
              ),
              Text('UPDATE PROFILE', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0))
            ],
          ),
        )),
    );
  }

  Widget _options(BuildContext context) {
    return SliverFillRemaining(
      child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          title: Text('Set display name', style: TextStyle(fontSize: 18.0)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SetDisplayNameScreen()));
          },
        ),
        ListTile(
          title: Text('Set username', style: TextStyle(fontSize: 18.0)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SetUsernameScreen()));
          },
        ),
        ListTile(
          title: Text('Set profile picture', style: TextStyle(fontSize: 18.0)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SetPictureScreen()));
          },
        ),
        ListTile(
          title: Text('Set profile tagline', style: TextStyle(fontSize: 18.0)),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (_) => SetTaglineScreen()));
          },
        ),
      ]),
    );
  }
}
