import 'dart:async';

import 'package:crust/config/config.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

final Link link = HttpLink(
  uri: Config.toasterHost + '/graphql',
) as Link;

final GraphQLClient client = GraphQLClient(
  link: link,
  cache: InMemoryCache(),
);

class Toaster {
  static Future<dynamic> get(String body, {Map<String, dynamic> variables}) {
    try {
      return client.query(QueryOptions(document: body.replaceAll('\n', ''), variables: variables)).then((response) {
        if (response.errors != null && response.errors.isNotEmpty) {
          print(response.errors.toString());
          return null;
        }
        return response.data;
      }).catchError((e) {
        print("===================2");
        print(e);
        return null;
      });
    } catch (e) {
      print("===================1");
      print(e);
      rethrow;
    }
  }
}
