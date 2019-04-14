import 'dart:async';
import 'dart:convert';

import 'package:crust/config/config.dart';
import 'package:http/http.dart' as http;

final url = Config.toasterHost + '/graphql';

final Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class Toaster {
  static Future<Map<String, dynamic>> get(String body, {Map<String, dynamic> variables}) async {
    var responseBody = json.encode({'query': body.replaceAll('\n', '') });
    var response = await http.post(url, body: responseBody, headers: headers);
    if (response.statusCode != 200) {
      print('Toaster request failed: ${body.trim().split(' ')[1]}');
      print('${response.statusCode} response: ${response.body}');
      return null;
    }
    return json.decode(response.body)['data'];
  }
}
