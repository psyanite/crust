import 'dart:async';
import 'dart:convert';

import 'package:crust/config/config.dart';
import 'package:http/http.dart' as http;

final url = '${Config.toasterHost}/graphql';

final Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

class Toaster {
  static Future<Map<String, dynamic>> get(String body, {Map<String, dynamic> variables}) async {
    var requestBody = json.encode({'query': body.replaceAll('\n', '') });
    var response = await http.post(url, body: requestBody, headers: headers);
    var responseBody = json.decode(response.body);
    if (response.statusCode != 200 || responseBody['errors'] != null) {
        print('Toaster request failed: {\n${body.trimRight()}\n}');
        print('${response.statusCode} response: ${response.body}');
        return null;
    }
    return responseBody['data'];
  }
}
