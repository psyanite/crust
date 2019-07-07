import 'package:crust/components/search/search_screen.dart';
import 'package:crust/models/store.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchIcon extends StatefulWidget {
  @override
  _SearchIconState createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  List<Store> stores = new List();

  @override
  Widget build(BuildContext context) {
    return IconButton(
        icon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 18.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())));
  }
}
