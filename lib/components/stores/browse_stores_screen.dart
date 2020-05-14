import 'package:crust/components/stores/favorite_stores_screen.dart';
import 'package:crust/components/stores/search_stores_screen.dart';
import 'package:crust/components/stores/stores_screen.dart';
import 'package:crust/components/stores/stores_side_scroller.dart';
import 'package:crust/models/curate.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class BrowseStoresScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          isLoggedIn: props.isLoggedIn,
        );
      },
    );
  }
}

class _Presenter extends StatelessWidget {
  final bool isLoggedIn;

  _Presenter({Key key, this.isLoggedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[_appBar(), _myFavoritesButton(context), _searchBar(context), _content()],
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      ),
    );
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 6.0, top: 38.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('EAT SLEEP DRINK REPEAT', style: Burnt.appBarTitleStyle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _myFavoritesButton(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.only(top: 33.0, bottom: 15.0, left: 16.0, right: 16.0),
        child: BurntButton(
          icon: CrustCons.heart,
          iconSize: 25.0,
          text: 'View My Favourites',
          padding: 10.0,
          fontSize: 20.0,
          onPressed: () {
            if (!isLoggedIn) {
              snack(context, 'Login now to favourite stores!');
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (_) => FavoriteStoresScreen()));
            }
          },
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.only(top: 10.0, bottom: 20.0),
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
    final curateTags = ['coffee', 'fancy', 'cheap', 'bubble', 'brunch', 'sweet'];
    return SliverToBoxAdapter(
      child: Column(children: List<Widget>.from(curateTags.map((c) => _CurateList(tag: c)))),
    );
  }
}

class _CurateList extends StatelessWidget {
  final String tag;

  _CurateList({Key key, this.tag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => store.state.store.curates[tag] ?? Curate(tag: tag, title: ''),
      builder: (context, c) {
        if (c.stores == null) return Container();
        var seeAll = () => Navigator.push(context, MaterialPageRoute(builder: (_) => StoresScreen(title: c.title, stores: c.stores)));
        return StoresSideScroller(c.stores, title: c.title, seeMore: seeAll);
      },
    );
  }
}

class _Props {
  final bool isLoggedIn;

  _Props({
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
    );
  }
}
