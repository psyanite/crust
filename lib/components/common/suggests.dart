import 'package:crust/components/common/components.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CuisineSuggest extends StatelessWidget {
  final SearchHistoryItem item;

  CuisineSuggest(this.item, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
      child: Container(
        color: Colors.transparent,
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  height: 40.0,
                  width: 40.0,
                  margin: EdgeInsets.only(top: 5.0, right: 5.0, bottom: 5.0, left: 4.0),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.0), color: Color(0xFFFFEFD1)),
                  child: Icon(CrustCons.bread_heart, color: Color(0xFFFFD58B), size: 30.0)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0, left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(item.cuisineName, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold))
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoreSuggest extends StatelessWidget {
  final MyStore.Store store;

  StoreSuggest(this.store, {Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              NetworkImg(store.coverImage, width: 50.0, height: 50.0),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                      Text(store.location ?? store.suburb, style: TextStyle(fontSize: 14.0)),
                      Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
