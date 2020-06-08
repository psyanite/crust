import 'dart:async';
import 'dart:convert' as Convert;
import 'dart:io';

import 'package:crust/components/common/components.dart';
import 'package:crust/components/screens/handle_notify_screen.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/services/local_notifier.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class FirebaseMessage {
  final String title;
  final String body;
  final String image;
  final String data;
  final Map<String, dynamic> dataMap;

  FirebaseMessage({this.title, this.body, this.image, this.data, this.dataMap});

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    var notification = json['notification'];
    var data = json['data'];
    return FirebaseMessage(
      title: notification['title'],
      body: notification['body'],
      image: data != null ? data['image'] : null,
      data: data != null ? Convert.json.encode(data) : "",
      dataMap: data != null ? Map<String, dynamic>.from(data) : Map<String, dynamic>(),
    );
  }
}

class FirebaseMessenger {
  static final FirebaseMessenger _singleton = FirebaseMessenger._internal();
  final FirebaseMessaging _fcm = FirebaseMessaging();
  static BuildContext _context;

  FirebaseMessenger._internal() {
    _fcm.configure(
      onMessage: _onMessage,
      onLaunch: _onLaunch,
      onResume: _onLaunch,
    );
    _fcm.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
  }

  Future<dynamic> _onMessage(Map<String, dynamic> json) async {
    try {
      var fbMessage = FirebaseMessage.fromJson(json);

      if (Platform.isAndroid) {
        await LocalNotifier(redirect: _redirect).notify(fbMessage);
      } else {
        _showFlushbar(fbMessage);
      }
    } catch (e, stack) {
      print('$e, $stack');
    }
  }

  _showFlushbar(FirebaseMessage msg) {
    var image = msg.image != null
        ? Padding(
            padding: EdgeInsets.only(top: 5.0),
            child: NetworkImg(msg.image, width: 50.0, height: 50.0),
          )
        : null;

    var body = Card(
      margin: EdgeInsets.all(0.0),
      elevation: 24.0,
      color: Burnt.paper,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(2.0)),
      child: Padding(
        padding: EdgeInsets.only(top: 16.0, bottom: 16.0, left: 8.0, right: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (image != null) image,
            Container(width: 10.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(msg.title, style: TextStyle(fontWeight: Burnt.fontBold)),
                  Text(
                    msg.body,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    var onTap = (Flushbar flush) {
      flush.dismiss();
      _redirect(msg.dataMap);
    };

    Flushbar(
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        messageText: body,
        duration: Duration(seconds: 10),
        backgroundColor: Colors.transparent,
        flushbarPosition: FlushbarPosition.TOP,
        dismissDirection: FlushbarDismissDirection.HORIZONTAL,
        onTap: onTap)
      ..show(_context);
  }

  Future<dynamic> _onLaunch(Map<String, dynamic> json) async {
    try {
      _redirect(Map<String, dynamic>.from(json['data']));
    } catch (e, stack) { print('$e, $stack'); }
  }

  _redirect(Map<String, dynamic> notify, {int count = 0}) {
    if (_context != null) {
      Navigator.push(_context, MaterialPageRoute(builder: (_) => HandleNotifyScreen(notify: notify)));
    } else if (count < 6) {
      Timer(Duration(milliseconds: 500), () => _redirect(notify, count: ++count));
    } else {
      throw Exception("Redirect timeout _context is null");
    }
  }

  Future<String> getToken() => _fcm.getToken();

  factory FirebaseMessenger({BuildContext context}) {
    if (context != null && _context != context) _context = context;
    return _singleton;
  }
}
