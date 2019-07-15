import 'package:crust/components/new_post/review_form.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:crust/state/store/store_actions.dart';
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
        ));
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
  String _query = '';
  TextEditingController _queryCtrl = TextEditingController();

  @override
  dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[_appBar()];
    if (!widget.isLoggedIn) {
      slivers.add(CenterTextSliver(text: 'Login now to write a review!'));
    } else {
      slivers.add(_searchBar());
      slivers.add(_query.trim().isEmpty ? _suggestions() : _searchResults(context));
    }
    return CustomScrollView(slivers: slivers);
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 20.0, bottom: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('WRITE A REVIEW', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
                Container(height: 50, width: 50),
              ],
            ),
          ],
        ),
      )),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: TextField(
        controller: _queryCtrl,
        onChanged: (text) {
          if (text.trim() != _query.trim()) setState(() => _query = text);
        },
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search for a restaurant, cafe, or eatery to review',
          prefixIcon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 18.0),
          suffixIcon: IconButton(icon: Icon(Icons.clear), onPressed: () {
            _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: ''));
            this.setState(() => _query = '');
          }),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _suggestions() {
    var filtered = [...widget.searchHistory].where((i) => i.store != null);
    var children = filtered.map<Widget>((i) => _SuggestCard(storeId: i.store.id, addSearchHistoryItem: widget.addSearchHistoryItem)).toList();
    return SliverToBoxAdapter(child: Column(children: children));
  }

  Widget _searchResults(BuildContext context) {
    return FutureBuilder<List<MyStore.Store>>(
      future: SearchService.searchStores(_query),
      builder: (context, AsyncSnapshot<List<MyStore.Store>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliver();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return SliverCenter(child: Text('Oops! Something went wrong, please try again'));
            } else if (snapshot.data.length == 0) {
              return SliverCenter(child: Text("Oops! We couldn't find anything, maybe try something different?"));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) => _ResultCard(store: snapshot.data[i], addSearchHistoryItem: widget.addSearchHistoryItem));
              }, childCount: snapshot.data.length),
            );
          default:
            return SliverToBoxAdapter(child: Text(''));
        }
      },
    );
  }
}

class _SuggestCard extends StatelessWidget {
  final int storeId;
  final Function addSearchHistoryItem;

  _SuggestCard({Key key, this.storeId, this.addSearchHistoryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) {
        if (store.state.store.stores == null) store.dispatch(FetchStoreByIdRequest(storeId));
      },
      converter: (Store<AppState> store) => store.state.store.stores[storeId],
      builder: (context, store) => _ResultCard(store: store, addSearchHistoryItem: addSearchHistoryItem)
    );
  }
}

class _ResultCard extends StatelessWidget {
  final MyStore.Store store;
  final Function addSearchHistoryItem;

  const _ResultCard({Key key, this.store, this.addSearchHistoryItem}) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: () {
      addSearchHistoryItem(store);
      Navigator.push(context, MaterialPageRoute(builder: (_) => ReviewForm(store: store)));
    },
    child: Padding(
      padding: EdgeInsets.only(top: 10.0, right: 15.0, left: 15.0),
      child: Container(
        child: IntrinsicHeight(
          child: Row(
            children: <Widget>[
              _listItemPromoImage(store),
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
    ));

  Widget _listItemPromoImage(MyStore.Store store) {
    return Container(
      width: 120.0,
      height: 100.0,
      decoration: BoxDecoration(
        color: Burnt.imgPlaceholderColor,
        image: DecorationImage(
          image: NetworkImage(store.coverImage),
          fit: BoxFit.cover,
        ),
      ));
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
      }
    );
  }
}
