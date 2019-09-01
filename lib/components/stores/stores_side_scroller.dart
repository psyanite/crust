import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'favorite_store_button.dart';

class StoresSideScroller extends StatelessWidget {
  final List<MyStore.Store> stores;
  final String title;
  final Function seeAll;
  final String emptyMessage;
  final bool confirmUnfavorite;

  StoresSideScroller({Key key, this.stores, this.title, this.seeAll, this.emptyMessage, this.confirmUnfavorite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var widgets = List<Widget>.from(stores.take(5).map((s) => _card(s)));
    return _list(widgets, seeAll);
  }

  Widget _list(List<Widget> children, Function seeAll) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(bottom: 5.0, left: 16.0, right: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title, style: TextStyle(fontSize: 23.0, fontWeight: Burnt.fontBold)),
              if (children.isNotEmpty)
                InkWell(
                  child: Text('See All', style: TextStyle(fontSize: 14.0, fontWeight: Burnt.fontBold, color: Burnt.primary)),
                  onTap: seeAll,
                )
            ],
          ),
        ),
        if (children.isNotEmpty)
          Container(
            margin: EdgeInsets.only(left: 16.0),
            height: 180.0,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: children,
            ),
          ),
        if (children.isEmpty) Container(margin: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 25.0), child: Text(emptyMessage)),
      ],
    );
  }

  Widget _card(MyStore.Store store) {
    return Builder(
        builder: (context) => InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)),
              );
            },
            child: Container(
                width: 200.0,
                height: 160.0,
                padding: EdgeInsets.only(right: 10.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Stack(alignment: AlignmentDirectional.topEnd, children: <Widget>[
                    Container(height: 100.0, width: 200.0, child: Image.network(store.coverImage, fit: BoxFit.cover)),
                    FavoriteStoreButton(store: store, padding: EdgeInsets.all(7.0), confirmUnfavorite: confirmUnfavorite)
                  ]),
                  Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    Container(height: 5.0),
                    Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                    Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                  ])
                ]))));
  }
}
