import 'dart:collection';

import 'package:crust/components/stores/search_stores_screen.dart';
import 'package:crust/components/stores/stores_screen.dart';
import 'package:crust/components/stores/stores_side_scroller.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/store/store_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BrowseStoresScreen extends StatefulWidget {
  @override
  _BrowseStoresScreenState createState() => _BrowseStoresScreenState();
}

class _BrowseStoresScreenState extends State<BrowseStoresScreen> {
  LinkedHashMap<String, Curate> _curates = LinkedHashMap<String, Curate>.from({
    'coffee': Curate(tag: 'coffee', title: 'Coffee At First Sight'),
    'fancy': Curate(tag: 'fancy', title: 'Absolutely Stunning'),
    'cheap': Curate(tag: 'cheap', title: 'Cheap Eats'),
    'bubble': Curate(tag: 'bubble', title: 'It\'s Bubble O\'clock'),
    'brunch': Curate(tag: 'brunch', title: 'Brunch Spots'),
    'sweet': Curate(tag: 'sweet', title: 'Sweet Tooth'),
  });

  @override
  initState() {
    super.initState();
    _loadCurates();
  }

  _loadCurates() {
    _curates.values.forEach((c) => _fetchStores(c));
  }

  _fetchStores(Curate c) async {
    var stores = await StoreService.fetchCurate(c.tag);
    stores.shuffle();
    var newCurate = c.copyWith(stores: stores);
    this.setState(() => _curates[newCurate.tag] = newCurate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[_appBar(), _searchBar(context), _content()],
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
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
              Text('EAT SLEEP DRINK REPEAT', style: Burnt.appBarTitleStyle)
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: InkWell(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Icon(CrustCons.search, color: Burnt.iconGrey, size: 20.0),
                Container(width: 8.0),
                Text('Search for a restaurant, cafe, or eatery', style: TextStyle(color: Burnt.hintTextColor))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _content() {
    var children = List<Widget>.from(_curates.values.map((c) {
      if (c.stores == null) return Container();
      var seeAll = () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoresScreen(title: c.title, stores: c.stores)));
      return StoresSideScroller(stores: c.stores, title: c.title, seeAll: seeAll);
    }));
    return SliverToBoxAdapter(
      child: Column(
        children: children,
      ),
    );
  }
}

class Curate {
  final String tag;
  final String title;
  final List<MyStore.Store> stores;

  Curate({
    this.tag,
    this.title,
    this.stores,
  });

  Curate copyWith({List<MyStore.Store> stores}) {
    return Curate(
      tag: this.tag,
      title: this.title,
      stores: stores ?? this.stores,
    );
  }
}
