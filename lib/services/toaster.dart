import 'dart:async';

import 'package:crust/config/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final Client client = Client(
  endPoint: Config.toasterHost + '/graphql',
  cache: InMemoryCache(),
);

class Toaster {
  static Future<dynamic> get(String body, {Map<String, dynamic> variables}) async {
    final Future<Map<String, dynamic>> response =
        client.query(query: body.replaceAll('\n', ''), variables: variables);
    return response;
  }
}
