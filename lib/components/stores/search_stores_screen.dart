import 'dart:async';

import 'package:crust/components/screens/report_missing_store_screen.dart';
import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart' as Geo;
import 'package:redux/redux.dart';

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          searchHistory: props.searchHistory,
          myAddress: props.myAddress,
          addSearchHistoryItem: props.addSearchHistoryItem,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final List<SearchHistoryItem> searchHistory;
  final Geo.Address myAddress;
  final Function addSearchHistoryItem;

  _Presenter({Key key, this.searchHistory, this.myAddress, this.addSearchHistoryItem}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  ScrollController _scrollie = ScrollController();
  Timer _typingTmr;
  TextEditingController _queryCtrl = TextEditingController();
  String _query = '';
  List<MyStore.Store> _results = List<MyStore.Store>();
  bool _loading = false;
  int _limit = 12;

  @override
  initState() {
    super.initState();
    _scrollie.addListener(() {
        if (_results.isNotEmpty
          && _loading == false
          && _limit > 0
          && _scrollie.position.extentAfter < 500) _fetch();
      });
  }

  @override
  dispose() {
    _scrollie.dispose();
    _queryCtrl.dispose();
    super.dispose();
  }

  _search() async {
    this.setState(() {
      _results = List<MyStore.Store>();
      _limit = 12;
    });
    _fetch();
  }

  _fetch() async {
    this.setState(() => _loading = true);
    var fresh = await SearchService.searchStores(widget.myAddress, _query, _limit, _results.length);
    this.setState(() => _loading = false);
    if (fresh.length < _limit) this.setState(() => _limit = 0);
    if (fresh.isNotEmpty) _results.addAll(fresh);
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      LocationBar(),
      _searchBar(),
      _query.isEmpty ? _suggestions() : _searchResults(context),
      SliverToBoxAdapter(child: Container(height: 40.0)),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers, controller: _scrollie));
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
              Text('SEARCH', style: Burnt.appBarTitleStyle)
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: TextField(
        controller: _queryCtrl,
        onChanged: (text) {
          this.setState(() {
            _query = text;
            _loading = true;
          });
          if (_typingTmr != null) setState(() => _typingTmr.cancel());
          setState(() => _typingTmr = new Timer(Duration(milliseconds: 600), _search));
        },
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        autocorrect: false,
        decoration: InputDecoration(
          hintText: 'Search for a restaurant, cafe, or eatery',
          prefixIcon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 18.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: ''));
              this.setState(() => _query = '');
            },
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _suggestions() {
    var children = widget.searchHistory.map<Widget>((i) {
      switch (i.type) {
        case SearchHistoryItemType.cuisine:
          return _cuisineSuggest(i);
          break;
        case SearchHistoryItemType.store:
          return _storeSuggest(i);
          break;
        default:
          return Container();
      }
    }).toList();
    return SliverToBoxAdapter(child: Column(children: children));
  }

  Widget _cuisineSuggest(SearchHistoryItem item) {
    return Builder(
      builder: (context) => InkWell(
        splashColor: Burnt.lightGrey,
        onTap: () {
          _scrollie.animateTo(0.0, curve: Curves.easeOut, duration: const Duration(milliseconds: 300));
          _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: item.cuisineName));
          this.setState(() {
            _query = item.cuisineName;
            _loading = true;
          });
          _search();
          widget.addSearchHistoryItem(item);
        },
        child: Padding(
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
                        children: <Widget>[Text(item.cuisineName, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold))],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _storeSuggest(SearchHistoryItem item) {
    var store = item.store;
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)));
          widget.addSearchHistoryItem(item);
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
          child: Container(
            child: IntrinsicHeight(
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  _storeImage(store),
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
        ),
      ),
    );
  }

  Widget _storeImage(MyStore.Store store) {
    return Container(
        width: 50.0,
        height: 50.0,
        decoration: BoxDecoration(
          color: Burnt.imgPlaceholderColor,
          image: DecorationImage(
            image: NetworkImage(store.coverImage),
            fit: BoxFit.cover,
          ),
        ));
  }

  Widget _searchResults(BuildContext context) {
    if (_loading == true) return LoadingSliverCenter();
    if (_results.isEmpty) return _cannotFind();
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        return Builder(builder: (context) {
          return _storeCard(_results[i]);
        });
      }, childCount: _results.length),
    );
  }

  Widget _cannotFind() {
    return SliverToBoxAdapter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(height: 40.0),
          Text("Can't find what you're looking for?"),
          Container(height: 15.0),
          SmallBurntButton(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportMissingStoreScreen())),
            child: Text('Let us know', style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 12.0, right: 12.0),
          ),
        ],
      ),
    );
  }

  Widget _storeCard(MyStore.Store store) {
    return Builder(
      builder: (context) => InkWell(
        onTap: () {
          widget.addSearchHistoryItem(SearchHistoryItem(type: SearchHistoryItemType.store, store: store));
          Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: store.id)));
        },
        child: Padding(
          padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
          child: Container(
            child: IntrinsicHeight(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 120.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: Burnt.imgPlaceholderColor,
                      image: DecorationImage(
                        image: NetworkImage(store.coverImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
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
        ),
      ),
    );
  }
}

class _Props {
  final Geo.Address myAddress;
  final List<SearchHistoryItem> searchHistory;
  final Function addSearchHistoryItem;

  _Props({this.myAddress, this.searchHistory, this.addSearchHistoryItem});

  static fromStore(Store<AppState> store) {
    return _Props(
      myAddress: store.state.me.address ?? Utils.defaultAddress,
      searchHistory: store.state.me.searchHistory,
      addSearchHistoryItem: (item) => store.dispatch(AddSearchHistoryItem(item)),
    );
  }
}
