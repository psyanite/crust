import 'package:crust/app/app_state.dart';
import 'package:crust/modules/home/home_actions.dart';
import 'package:crust/modules/home/models/store.dart' as MyStore;
import 'package:crust/modules/home/components/store_card.dart';
import 'package:crust/modules/loading/loading_screen.dart';
import 'package:crust/presentation/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: AppBar(
              backgroundColor: themeColors['primary_light'],
              elevation: 0.0,
              title: const Text('Burntoast', style: const TextStyle(color: Color(0xFFFFFFFF), fontSize: 40.0, fontFamily: 'GrandHotel')))),
      body: _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    return StoreConnector<AppState, List<MyStore.Store>>(
      onInit: (Store<AppState> store) => store.dispatch(FetchStoresRequest()),
      converter: (Store<AppState> store) {
        return store.state.home.stores;
      },
      builder: (BuildContext context, List<MyStore.Store> stores) {
        return stores == null ?
        new LoadingScreen()
          :
        new ListView.builder(
          itemCount: stores.length,
          itemBuilder: (context, position) =>
          new StoreCard(stores[position]));
      },
    );
  }

}
