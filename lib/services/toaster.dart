import 'dart:async';
import 'dart:convert';

import 'package:crust/config/config.dart';
import 'package:http/http.dart' as http;

final url = '${Config.toasterHost}/graphql';

final Map<String, String> headers = {
  'Authorization': 'Bearer breadcat',
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class Toaster {
  static Future<Map<String, dynamic>> get(String body, {Map<String, dynamic> variables}) async {
    var requestBody = json.encode({'query': body });
    var response = await http.post(url, body: requestBody, headers: headers);
    var responseBody;
    try { responseBody = json.decode(response.body); } catch (e, stack) { print('$e, $stack'); }
    if (response.statusCode != 200 || responseBody == null || responseBody['errors'] != null) {
      print('[ERROR] Toaster request failed: {\n${body.trimRight()}\n}');
      print('[ERROR] ${response.statusCode} response: ${response.body}');
      return Map<String, dynamic>();
    }
    return responseBody['data'];
  }
}
