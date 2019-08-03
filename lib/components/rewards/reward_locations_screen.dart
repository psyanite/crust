import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/models/store_group.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RewardLocationsScreen extends StatelessWidget {
  final StoreGroup group;

  RewardLocationsScreen({Key key, this.group}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), _content()];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
                ],
              ),
              Text(group.name, style: Burnt.display4),
              Container(height: 10.0),
              Text('Redeem this reward at the following locations')
            ],
          ),
        ),
      ),
    );
  }

  Widget _content() {
    return SliverToBoxAdapter(
      child: ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 0.0),
          shrinkWrap: true,
          itemBuilder: (context, index) => _storeCard(group.stores[index]),
          separatorBuilder: (context, index) => Divider(color: Color(0xFFDDDDDD)),
          itemCount: group.stores.length,
        ),
    );
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id))),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                _details(store),
                _map(context, store),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _details(MyStore.Store store) {
    var address = store.address;
    var firstLine = "";
    if (address.firstLine != null) firstLine += "${address.firstLine}";
    if (address.secondLine != null) firstLine += ", ${address.secondLine}";
    var secondLine = "${address.streetNumber} ${address.streetName}";
    if (store.location != null) secondLine += ", ${store.location}";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(store.location ?? store.suburb, style: TextStyle(fontSize: 20.0)),
        Container(height: 3.0),
        if (firstLine.isNotEmpty) Text(firstLine),
        Text(secondLine),
        if (store.suburb != null) Text(store.suburb),
      ],
    );
  }

  Widget _map(BuildContext context, MyStore.Store store) {
    return InkWell(
      splashColor: Burnt.splashOrange,
      highlightColor: Colors.transparent,
      onTap: () => launch(store.address.googleUrl),
      child: Icon(CrustCons.location_bold, size: 35.0, color: Burnt.iconOrange),
    );
  }
}
