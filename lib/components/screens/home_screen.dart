import 'package:crust/components/screens/scan_qr_screen.dart';
import 'package:crust/components/search/search_screen.dart';
import 'package:crust/components/stores/stores_grid.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/reward/reward_actions.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:redux/redux.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      onInit: (Store<AppState> store) {
        store.dispatch(FetchStoresRequest());
        store.dispatch(FetchTopStoresRequest());
        store.dispatch(FetchFavoritesRequest());
        if (store.state.me.user != null) store.dispatch(FetchMyPostsRequest(store.state.me.user.id));
        store.dispatch(FetchRewardsRequest());
        store.dispatch(FetchTopRewardsRequest());
      },
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          stores: props.stores,
          topStores: props.topStores,
          topRewards: props.topRewards,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final List<MyStore.Store> stores;
  final List<MyStore.Store> topStores;
  final List<Reward> topRewards;

  _Presenter({Key key, this.stores, this.topStores, this.topRewards}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    return Scaffold(body: CustomScrollView(slivers: <Widget>[_appBar(), _topStores(context), _topRewards(context), StoresGrid(stores: stores)]));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          height: 100.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Burntoast',
                style: TextStyle(
                  color: Burnt.primary,
                  fontSize: 44.0,
                  fontFamily: Burnt.fontFancy,
                  fontWeight: Burnt.fontLight,
                  letterSpacing: 0.0,
                ),
              ),
              Row(children: <Widget>[_searchIcon(), _qrIcon()])
            ],
          ),
        ),
      ),
    );
  }

  Widget _topStores(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(height: 20.0),
          Text('WHAT\'S HOT 🔥', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
          Container(height: 15.0),
          Container(
            height: 450.0,
            child: Swiper(
              containerHeight: 200.0,
              itemBuilder: (BuildContext context, int i) {
                return Stack(
                  children: <Widget>[
                    Container(height: 310),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        boxShadow: [BoxShadow(color: Color(0x10000000), offset: Offset(2.0, 2.0), blurRadius: 1.0, spreadRadius: 1.0)],
                      ),
                      child: _topStoreCard(topStores[i]),
                    ),
                  ],
                );
              },
              itemCount: topStores.length,
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topStoreCard(MyStore.Store store) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 300.0,
          decoration: BoxDecoration(
            color: Burnt.imgPlaceholderColor,
            image: DecorationImage(
              image: NetworkImage(store.coverImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(top: 16.0, bottom: 20.0, left: 16.0, right: 16.0),
          child: Column(
            children: <Widget>[
              Text(store.name, style: TextStyle(fontSize: 22.0, fontWeight: Burnt.fontBold)),
              Text(store.location ?? store.suburb, style: TextStyle(fontSize: 16.0)),
              Text(store.cuisines.join(', '), style: TextStyle(fontSize: 16.0)),
            ],
          ),
        ),
//        Container(
//          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
//          height: 100.0,
//          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            mainAxisAlignment: MainAxisAlignment.spaceBetween,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              Column(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: <Widget>[
//                  Text(store.name, style: TextStyle(fontSize: 24.0, fontWeight: Burnt.fontBold)),
//                  Text(store.location ?? store.suburb, style: TextStyle(fontSize: 18.0)),
//                  Text(store.cuisines.join(', '), style: TextStyle(fontSize: 18.0)),
//                ],
//              ),
//              Row(
//                mainAxisSize: MainAxisSize.min,
//                crossAxisAlignment: CrossAxisAlignment.center,
//                children: <Widget>[
//                  Text(store.heartCount.toString(), style: TextStyle(fontSize: 18.0)),
//                  Container(width: 5.0),
//                  Container(height: 32.0, child: ScoreIcon(score: Score.good, size: 30.0)),
//                ],
//              )
//            ],
//          ),
//        ),
      ],
    );
  }

  Widget _topRewards(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
        children: <Widget>[
          Container(height: 20.0),
          Text('TOP PICKS 👍', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
          Container(height: 15.0),
          Container(
            height: 500.0,
            child: Swiper(
              containerHeight: 200.0,
              itemBuilder: (BuildContext context, int i) {
                return Stack(
                  children: <Widget>[
                    Container(height: 310),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(2.0)),
                        boxShadow: [BoxShadow(color: Color(0x10000000), offset: Offset(2.0, 2.0), blurRadius: 1.0, spreadRadius: 1.0)],
                      ),
                      child: _topRewardCard(topRewards[i]),
                    ),
                  ],
                );
              },
              itemCount: topRewards.length,
              viewportFraction: 0.8,
              scale: 0.9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _topRewardCard(Reward reward) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          height: 300.0,
          decoration: BoxDecoration(
            color: Burnt.imgPlaceholderColor,
            image: DecorationImage(
              image: NetworkImage(reward.promoImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(height: 20.0),
        Text(reward.name, style: Burnt.titleStyle.copyWith(fontSize: 22.0)),
        Container(height: 2.0),
        Text(reward.storeNameText(), style: TextStyle(fontSize: 16.0)),
        Container(height: 2.0),
        Text(reward.locationText(), style: TextStyle(fontSize: 16.0)),
        Container(height: 3.0),
        Text(reward.bannerText(), style: TextStyle(color: Burnt.hintTextColor, fontSize: 16.0)),
        Container(height: 20.0),
      ],
    );
  }

  Widget _searchIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 21.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SearchScreen())),
      );
    });
  }

  Widget _qrIcon() {
    return Builder(builder: (context) {
      return IconButton(
        icon: Icon(CrustCons.qr, color: Color(0x50604B41), size: 23.0),
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ScanQrScreen())),
      );
    });
  }
}

class _Props {
  final List<MyStore.Store> stores;
  final List<MyStore.Store> topStores;
  final List<Reward> topRewards;

  _Props({
    this.stores,
    this.topStores,
    this.topRewards,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      stores: store.state.store.stores.values.toList(),
      topStores: store.state.store.topStores.values.toList(),
      topRewards: store.state.reward.topRewards.values.toList(),
    );
  }
}
