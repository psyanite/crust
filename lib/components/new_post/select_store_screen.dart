import 'dart:async';

import 'package:crust/components/new_post/review_form.dart';
import 'package:crust/components/screens/report_missing_store_screen.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectStoreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) => _Presenter(
        isLoggedIn: props.isLoggedIn,
        searchHistory: props.searchHistory,
        addSearchHistoryItem: props.addSearchHistoryItem,
      ),
    );
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final List<SearchHistoryItem> searchHistory;
  final Function addSearchHistoryItem;

  _Presenter({Key key, this.isLoggedIn, this.searchHistory, this.addSearchHistoryItem}) : super(key: key);

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
      if (_results.isNotEmpty && _loading == false && _limit > 0 && _scrollie.position.extentAfter < 500) _fetch();
    });
  }

  @override
  dispose() {
    _scrollie.dispose();
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar(), ..._content(context)];
    return Scaffold(body: CustomScrollView(slivers: slivers, controller: _scrollie));
  }

  List<Widget> _content(context) {
    if (!widget.isLoggedIn) return <Widget>[CenterTextSliver(text: 'Login now to write a review!')];
    return <Widget>[
      _searchBar(),
      _query.trim().isEmpty ? _suggestions() : _searchResults(context),
      SliverToBoxAdapter(child: Container(height: 40.0)),
    ];
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
    var fresh = await SearchService.searchStoreByName(_query, _limit, _results.length);
    this.setState(() => _loading = false);
    if (fresh.length < _limit) this.setState(() => _limit = 0);
    if (fresh.isNotEmpty) _results.addAll(fresh);
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 20.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('WRITE A REVIEW', style: Burnt.appBarTitleStyle),
                  Container(height: 50, width: 50),
                ],
              ),
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
        decoration: InputDecoration(
          hintText: 'Search for a restaurant, cafe, or eatery to review',
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
    var filtered = [...widget.searchHistory].where((i) => i.store != null).toList();
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        return Builder(
          builder: (context) => _StoreCard(store: filtered[i].store, addSearchHistoryItem: widget.addSearchHistoryItem),
        );
      }, childCount: filtered.length),
    );
  }

  Widget _searchResults(BuildContext context) {
    if (_loading == true) return LoadingSliverCenter();
    if (_results.isEmpty) return _letUsKnow();
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        return Builder(builder: (context) {
          if (i >= _results.length) return _cannotFind();
          return _StoreCard(store: _results[i], addSearchHistoryItem: widget.addSearchHistoryItem);
        });
      }, childCount: _results.length + 1),
    );
  }

  Widget _letUsKnow() {
    return SliverCenter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Sorry, couldn't find anything matching that."),
          Container(height: 15.0),
          SmallBurntButton(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ReportMissingStoreScreen())),
            child: Text('Let us know', style: TextStyle(color: Colors.white)),
            padding: EdgeInsets.only(top: 10.0, bottom: 10.0, left: 12.0, right: 12.0),
          )
        ],
      ),
    );
  }

  Widget _cannotFind() {
    return Column(
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
        Container(height: 40.0),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  final MyStore.Store store;
  final Function addSearchHistoryItem;

  const _StoreCard({Key key, this.store, this.addSearchHistoryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        addSearchHistoryItem(store);
        Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewForm(store: store)));
      },
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
        child: Container(
          child: IntrinsicHeight(
            child: Row(
              children: <Widget>[
                NetworkImg(store.coverImage, width: 120.0, height: 100.0),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                        Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
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
    );
  }
}

class _Props {
  final bool isLoggedIn;
  final List<SearchHistoryItem> searchHistory;
  final Function addSearchHistoryItem;

  _Props({
    this.isLoggedIn,
    this.searchHistory,
    this.addSearchHistoryItem,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
      searchHistory: store.state.me.searchHistory,
      addSearchHistoryItem: (myStore) {
        var item = SearchHistoryItem(type: SearchHistoryItemType.store, store: myStore);
        store.dispatch(AddSearchHistoryItem(item));
      },
    );
  }
}
