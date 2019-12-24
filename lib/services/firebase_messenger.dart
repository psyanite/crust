import 'dart:async';

import 'package:crust/components/screens/handle_notify_screen.dart';
import 'package:crust/services/local_notifier.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:convert' as Convert;

class FirebaseMessage {
  final String title;
  final String body;
  final String imageUrl;
  final String data;

  FirebaseMessage({this.title, this.body, this.imageUrl, this.data});

  factory FirebaseMessage.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    var notification = json['notification'];
    return FirebaseMessage(
      title: notification['title'],
      body: notification['body'],
      imageUrl: notification['imageUrl'],
      data: Convert.json.encode(json['data']),
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
    _fcm.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true, provisional: true));
  }

  Future<dynamic> _onMessage(Map<String, dynamic> json) async {
    try {
      var fbMessage = FirebaseMessage.fromJson(json);
      await LocalNotifier(redirect: _redirect).notify(fbMessage);
    } catch (e, stack) { print('$e, $stack'); }
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
