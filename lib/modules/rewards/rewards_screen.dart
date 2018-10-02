import 'package:crust/presentation/colors.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
    RewardsScreen({Key key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return new Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60.0),
            child: AppBar(
              backgroundColor: themeColors['white'],
              elevation: 0.0,
              title: const Text(
                'Rewards',
                style: const TextStyle(
                  color: Color(0xFF604B41),
                  fontSize: 30.0,
                  fontFamily: 'OpenSans'
                )
              )
            )
          )
        );
    }

}