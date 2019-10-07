import 'package:crust/components/common/banners.dart';
import 'package:crust/components/my_profile/set_display_name_screen.dart';
import 'package:crust/components/my_profile/set_picture_screen.dart';
import 'package:crust/components/my_profile/set_tagline_screen.dart';
import 'package:crust/components/my_profile/set_username_screen.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UpdateProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _options(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: <Widget>[
              MyBanner(),
              Positioned(child: BackArrow(color: Colors.white)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _options(BuildContext context) {
    return SliverFillRemaining(
      child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
        Container(
            padding: EdgeInsets.only(top: 25.0, left: 15.0, bottom: 10.0), child: Text('UPDATE PROFILE', style: Burnt.appBarTitleStyle)),
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
