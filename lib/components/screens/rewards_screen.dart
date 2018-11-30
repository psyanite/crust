import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';

class RewardsScreen extends StatelessWidget {
  RewardsScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: <Widget>[_appBar(), _content()]);
  }

  Widget _appBar() {
    return SliverAppBar(
      pinned: false,
      floating: false,
      expandedHeight: 60.0,
      backgroundColor: Burnt.primaryLight,
      elevation: 24.0,
      title: Text('Rewards', style: TextStyle(color: Colors.white, fontSize: 40.0, fontFamily: Burnt.fontFancy)));
  }

  Widget _card() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Column(
        children: <Widget>[
          Container(
            height: 100.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage('https://imgur.com/tR1bD1v.jpg'),
                fit: BoxFit.cover,
              ),
            )),
          Text("Double Mex Tuesday"),
          Row(children: <Widget>[Text("Mad Mex"), Text("Strathfield, Town Hall"), Text(" +3 locations")]),
          Text("Buy one regular or naked burrito from Mad Mex and receive the second one for free! Add a drink for only \$1! Hurry, only available on Tuesdays.")
        ],
      ),
    );
  }

  Widget _content() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          child: Column(


            children: <Widget>[
              _card()


            ],

          )
        )
      ])
    );
  }
}
