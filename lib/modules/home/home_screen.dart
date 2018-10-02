import 'package:crust/presentation/colors.dart';
import 'package:flutter/material.dart';

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
      )
    );
  }

}