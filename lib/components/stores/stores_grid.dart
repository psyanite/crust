import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/components/stores/favorite_store_button.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/theme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class StoresGrid extends StatelessWidget {
  final List<MyStore.Store> stores;
  final bool confirmUnfavorite;

  StoresGrid({Key key, this.stores, this.confirmUnfavorite = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (stores.isEmpty) return _skelly();
    stores.sort((a, b) => a.id.compareTo(b.id));
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      delegate: SliverChildBuilderDelegate((builder, i) => _storeCard(stores[i]), childCount: stores.length),
    );
  }

  Widget _skelly() {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      delegate: SliverChildBuilderDelegate(
          (builder, i) {
          return Shimmer.fromColors(
            baseColor: Color(0xFFF0F0F0),
            highlightColor: Color(0xFFF7F7F7),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Container(
                width: 100.0,
                height: 100.0,
                color: Colors.white,
              ),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Container(height: 8.0),
                Container(height: 8.0, width: 150.0, color: Colors.white),
                Container(height: 8.0),
                Container(height: 8.0, width: 100.0, color: Colors.white),
              ])
            ]),
          );
        },
        childCount: 20),
    );
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)),
            );
          },
          child: Container(
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
              Stack(
                alignment: AlignmentDirectional.topEnd,
                children: <Widget>[
                  Container(
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Burnt.imgPlaceholderColor,
                      image: DecorationImage(
                        image: NetworkImage(store.coverImage),
                        fit: BoxFit.cover,
                      ),
                    )),
                  FavoriteStoreButton(store: store, padding: EdgeInsets.all(7.0), confirmUnfavorite: confirmUnfavorite),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8.0, top: 5.0),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                  Text(store.location ?? store.suburb, style: TextStyle(fontSize: 14.0)),
                  Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                ]))
            ])),
        );
      },
    );
  }
}
