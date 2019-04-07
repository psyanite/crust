import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:crust/config/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final Client client = Client(
  endPoint: Config.toasterHost + '/graphql',
  cache: InMemoryCache(),
);

class Toaster {
  static Future<dynamic> get(String body, {Map<String, dynamic> variables}) async {
    Future<Map<String, dynamic>> response;
    try {
      response = client.query(query: body.replaceAll('\n', ''), variables: variables);
    } on NoConnectionException catch (e) {
      print("NoConnectionException " + e.toString());
    } on http.ClientException catch (e) {
      print("ClientException " + e.toString());
      rethrow;
    } on GQLException catch (e) {
      print("GQLException " + e.toString());
      rethrow;
    }
    return response;
  }
}
