import 'package:crust/services/firebase_messenger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:convert' as Convert;

class LocalNotifier {
  static final LocalNotifier _singleton = LocalNotifier._internal();
  final FlutterLocalNotificationsPlugin _notifier = FlutterLocalNotificationsPlugin();
  Directory _fileDir;
  static Function _redirect;

  LocalNotifier._internal() {
    final androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iosSettings = IOSInitializationSettings();
    _notifier.initialize(
      InitializationSettings(androidSettings, iosSettings),
      onSelectNotification: _onSelect,
    );
    _initImageDir();
  }

  _initImageDir() async {
    _fileDir = await getApplicationDocumentsDirectory();
  }

  Future _onSelect(String payload) async {
    try {
      var notify = Map<String, dynamic>.from(Convert.json.decode(payload));
      _redirect(notify);
    } catch (e, stack) { print('$e, $stack'); }
  }

  Future notify(FirebaseMessage message) async {
    var specs = await _getPlatformChannelSpecs(message);
    await LocalNotifier()._notifier.show(message.hashCode, message.title, message.body, specs, payload: message.data);
  }

  Future<NotificationDetails> _getPlatformChannelSpecs(FirebaseMessage message) async {
    var image = message.imageUrl;
    var largeIcon = image != null ? await _getFilePath(image) : null;

    var androidSpecs = AndroidNotificationDetails(
      message.hashCode.toString(), 'Burntoast', 'Burntoast',
      largeIcon: largeIcon,
      largeIconBitmapSource: largeIcon != null ? BitmapSource.FilePath : null,
      style: AndroidNotificationStyle.BigText,
      styleInformation: null,
      importance: Importance.Max, priority: Priority.High,
    );

    var iosSpecs = IOSNotificationDetails();

    return NotificationDetails(androidSpecs, iosSpecs);
  }

  Future<String> _getFilePath(String url) async {
    if (_fileDir == null) await _initImageDir();
    var filePath = '${_fileDir.path}/notify-image-${url.hashCode}';
    var file = File(filePath);
    if (! await file.exists()) {
      var response = await http.get(url);
      await file.writeAsBytes(response.bodyBytes);
    }

    return filePath;
  }

  factory LocalNotifier({Function redirect}) {
    if (redirect != null && _redirect != redirect) _redirect = redirect;
    return _singleton;
  }
}
