import 'package:crust/app/app_state.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/models/store.dart' as MyStore;
import 'package:crust/presentation/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

List<MyStore.Store> recipes = [];

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<MyStore.Store>>(
      onInit: (Store<AppState> store) => store.dispatch(FetchStoresRequest()),
      converter: (Store<AppState> store) {
        return store.state.home.stores;
      },
      builder: (BuildContext context, List<MyStore.Store> stores) {
        recipes = stores;
        return CustomScrollView(slivers: <Widget>[_appBar(), _main(stores)]);
      },
    );
  }

  Widget _appBar() {
    return new SliverAppBar(
      pinned: false,
      floating: false,
      expandedHeight: 60.0,
      backgroundColor: themeColors['primary_light'],
      elevation: 24.0,
      title: Text('Burntoast', style: TextStyle(color: themeColors['white'], fontSize: 40.0, fontFamily: themeText['fancy']))
    );
  }

  Widget _loadingSliver() {
    return new SliverFillRemaining(
      child: new Container(
        child: new Center(
          child: new CupertinoActivityIndicator(),
        ),
      ),
    );
  }

  Widget _gridSliver(stores) {
    return new SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.2,
        crossAxisSpacing: 5.0,
        mainAxisSpacing: 5.0,
      ),
      delegate: SliverChildListDelegate(
        List<Widget>.from(stores.map(_storeCard))
      )
    );
  }

  Widget _storeCard(MyStore.Store store) {

    var titleStyle = TextStyle(color: themeText['body'], fontFamily: themeText['base']);
    var descStyle = TextStyle(color: themeText['body'], fontSize: 12.0, fontFamily: themeText['base'], fontWeight: FontWeight.w100);

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            color: Colors.red,
            height: 100.0,
            child: Image.network(store.coverImage, fit: BoxFit.cover)
          ),
          Padding(
            padding: EdgeInsets.only(left: 8.0, top: 5.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(store.name, style: titleStyle),
                Text(store.location != null ? store.location : store.suburb, style: descStyle),
                Text(store.cuisines.join(', '), style: descStyle),
              ]
            )
          )
        ]
      )
    );
  }


  Widget _main(stores) {
    return stores == null ? _loadingSliver() : _gridSliver(stores);
  }
}
