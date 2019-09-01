import 'package:crust/components/stores/store_screen.dart';
import 'package:crust/components/search/select_location_screen.dart';
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

class SearchRewardsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          location: props.location,
          addSearchHistoryItem: props.addSearchHistoryItem,
          setMyLocation: props.setMyLocation,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final SearchLocationItem location;
  final Function addSearchHistoryItem;
  final Function setMyLocation;

  _Presenter({Key key, this.location, this.addSearchHistoryItem, this.setMyLocation})
    : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _query = '';
  SearchLocationItem _location;
  bool _submit = false;
  TextEditingController _queryCtrl = TextEditingController();

  @override
  initState() {
    super.initState();
    _location = widget.location;
  }

  @override
  dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _locationBar(),
      _searchBar(),
      if (_submit) _searchResults(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  selectLocation(SearchLocationItem newLocation) {
    this.setState(() => _location = newLocation);
    widget.setMyLocation(newLocation);
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

  Widget _locationBar() {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => SelectLocationScreen(current: _location, selectLocation: selectLocation),
            ),
          );
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(width: 14.0),
                Icon(CrustCons.location_bold, color: Burnt.lightGrey, size: 22.0),
                Container(width: 12.0),
                Text("${_location.name}, ${_location.description}", style: TextStyle(fontSize: 18.0)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: TextField(
        controller: _queryCtrl,
        onChanged: (text) {
          if (text.trim() != _query.trim()) setState(() => _query = text);
        },
        onSubmitted: (text) => this.setState(() => _submit = true),
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search for a restaurant, cafe, or eatery',
          prefixIcon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 18.0),
          suffixIcon: IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: ''));
              this.setState(() {
                _submit = false;
                _query = '';
              });
            }),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _searchResults(BuildContext context) {
    if (_query.isEmpty) {
      return SliverCenter(child: Container());
    }
    return FutureBuilder<List<MyStore.Store>>(
      future: SearchService.searchStores(_query.trim()),
      builder: (context, AsyncSnapshot<List<MyStore.Store>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliverCenter();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return SliverCenter(child: Text('Oops! Something went wrong, please try again'));
            } else if (snapshot.data.length == 0) {
              return SliverCenter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Oops! We couldn't find anything, maybe try something different?"),
                ));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) => _storeCard(snapshot.data[i]));
              }, childCount: snapshot.data.length),
            );
          default:
            return SliverCenter(child: Container());
        }
      },
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
                    )),
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
        )),
    );
  }
}

class _Props {
  final List<SearchHistoryItem> searchHistory;
  final SearchLocationItem location;
  final Function addSearchHistoryItem;
  final Function setMyLocation;

  _Props({this.searchHistory, this.location, this.addSearchHistoryItem, this.setMyLocation});

  static fromStore(Store<AppState> store) {
    return _Props(
      searchHistory: store.state.me.searchHistory,
      location: store.state.me.location,
      addSearchHistoryItem: (item) => store.dispatch(AddSearchHistoryItem(item)),
      setMyLocation: (location) => store.dispatch(SetMyLocation(location)));
  }
}
