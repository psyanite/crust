import 'package:flutter/material.dart';

class FavoritesScreen extends StatelessWidget {
  FavoritesScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
                backgroundColor: Colors.white,
                elevation: 0.0,
                title: const Text('Favorites', style: const TextStyle(color: Color(0xFF604B41), fontSize: 30.0)))));
  }
}
