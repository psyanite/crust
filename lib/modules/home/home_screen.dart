import 'package:crust/presentation/colors.dart';
import 'package:crust/services/toaster.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//class Store {
//  final int userId;
//  final int id;
//  final String title;
//  final String body;
//
//  Post({this.userId, this.id, this.title, this.body});
//
//  factory Post.fromJson(Map<String, dynamic> json) {
//    return Post(
//      userId: json['userId'],
//      id: json['id'],
//      title: json['title'],
//      body: json['body'],
//    );
//  }
//}

//Future<Store> fetchPost() async {
//  final response =
//  await http.get('https://jsonplaceholder.typicode.com/posts/1');
//
//  if (response.statusCode == 200) {
//    // If the call to the server was successful, parse the JSON
//    return Post.fromJson(json.decode(response.body));
//  } else {
//    // If that call was not successful, throw an error.
//    throw Exception('Failed to load post');
//  }
//}

Future fetchMeow() async {
  String getAllStores = """
    query {
      allStores {
        id,
        name
      } 
    }
  """;
  await Toaster.get(getAllStores);
}

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          backgroundColor: themeColors['primary_light'],
          elevation: 0.0,
          title: const Text(
            'Burntoast',
            style: const TextStyle(
              color: Color(0xFFFFFFFF),
              fontSize: 40.0,
              fontFamily: 'GrandHotel'
            )
          )
        )
      ),
      body: Center(
        child: FutureBuilder(
          future: fetchMeow(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Text(snapshot.data.title);
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }

}