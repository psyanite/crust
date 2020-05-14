import 'dart:io';

import 'package:crust/components/common/banners.dart';
import 'package:crust/components/screens/privacy_screen.dart';
import 'package:crust/components/screens/terms_screen.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:device_info/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({Key key}) : super(key: key);

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
        Container(padding: EdgeInsets.only(top: 25.0, left: 15.0, bottom: 10.0), child: Text('ABOUT', style: Burnt.appBarTitleStyle)),
        ListTile(
          title: Text('Contact Us', style: TextStyle(fontSize: 18.0)),
          onTap: () => launch(Utils.buildEmail('', '(insert-your-query-here)')),
        ),
        ListTile(
          title: Text('Report an Issue', style: TextStyle(fontSize: 18.0)),
          onTap: () => _reportAnIssue(),
        ),
        ListTile(
          title: Text('Terms of Use', style: TextStyle(fontSize: 18.0)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => TermsScreen())),
        ),
        ListTile(
          title: Text('Privacy Policy', style: TextStyle(fontSize: 18.0)),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => PrivacyScreen())),
        ),
      ]),
    );
  }

  _reportAnIssue() async {
    var info;
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        var data = await deviceInfo.androidInfo;
        info = """
          platform: android
          type: ${data.isPhysicalDevice ? 'physical' : 'non-physical'}
          brand: ${data.brand}
          manufacturer: ${data.manufacturer}
          hardware: ${data.hardware}
          model: ${data.model}
          device: ${data.device}
          version: ${data.version.baseOS}-${data.version.release}-${data.version.sdkInt}-${data.version.securityPatch}
        """;
      } else if (Platform.isIOS) {
        var data = await deviceInfo.iosInfo;
        info = """
          platform: android
          type: ${data.isPhysicalDevice ? 'physical' : 'non-physical'}
          name: ${data.name}
          systemName: ${data.systemName}
          systemVersion: ${data.systemVersion}
          model: ${data.model}
        """;
      } else {
        info = 'error-could-not-determine-platform';
      }
    } on PlatformException {
      info = 'platform-exception-could-not-get-device-info';
    }
    launch(Utils.buildEmail('Issue Report', '(describe-your-issue-here)<br><br><br>Diagnostics<br><br>$info'));
  }
}
