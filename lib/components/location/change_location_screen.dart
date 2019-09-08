import 'package:crust/components/location/use_my_location.dart';
import 'package:crust/models/search.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:redux/redux.dart';

class ChangeLocationScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (context, props) {
        return _Presenter(myAddress: props.myAddress, select: props.select);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final Address myAddress;
  final Function select;

  _Presenter({Key key, this.myAddress, this.select}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  String _query = '';
  TextEditingController _queryCtrl;

  @override
  initState() {
    super.initState();
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
      _searchBar(),
      SliverToBoxAdapter(child: MyLocation(onTap: (address) {
        widget.select(address);
        Navigator.pop(context);
      })),
      _searchLocation(context),
      _searchGeo(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 2.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(
                    left: -12.0,
                    child: IconButton(
                      icon: Icon(CrustCons.back, color: Burnt.lightGrey),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                ],
              ),
              Text('CHANGE LOCATION', style: Burnt.appBarTitleStyle)
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
          if (text.trim() != _query) setState(() => _query = text.trim());
        },
        style: TextStyle(fontSize: 18.0),
        autofocus: true,
        decoration: InputDecoration(
          hintText: 'Search for a location',
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

  Widget _searchLocation(BuildContext context) {
    if (_query.isEmpty) return SliverToBoxAdapter();
    return FutureBuilder(
      future: SearchService.searchLocations(_query, 3),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliverCenter();
          case ConnectionState.done:
            if (snapshot.hasError) {
              print(snapshot.error);
              return SliverToBoxAdapter();
            } else if (snapshot.data.length == 0) {
              return SliverToBoxAdapter();
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) {
                  SearchLocationItem s = snapshot.data[i];
                  return _resultCard(s.toGeoAddress());
                });
              }, childCount: snapshot.data.length),
            );
          default:
            return SliverCenter(child: Container());
        }
      },
    );
  }

  Widget _searchGeo(BuildContext context) {
    if (_query.isEmpty) return SliverToBoxAdapter();
    return FutureBuilder(
      future: Geocoder.local.findAddressesFromQuery(_query).timeout(Duration(seconds: 10), onTimeout: () => []),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliverCenter();
          case ConnectionState.done:
            if (snapshot.hasError || snapshot.data.length == 0) {
              return SliverCenter(child: Text("No Results Found"));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) => _resultCard(snapshot.data[i]));
              }, childCount: snapshot.data.length),
            );
          default:
            return SliverCenter(child: Container());
        }
      },
    );
  }

  Widget _resultCard(Address a) {
    return InkWell(
      onTap: () {
        widget.select(a);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(a.addressLine.split(',')[0] ?? '', style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
            Text(a.locality ?? '', style: TextStyle(fontSize: 18.0)),
            Container(height: 10.0)
          ],
        ),
      ),
    );
  }
}

class _Props {
  final Address myAddress;
  final Function select;

  _Props({
    this.myAddress,
    this.select,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      myAddress: store.state.me.address,
      select: (suburb) => store.dispatch(SetMyAddress(suburb)),
    );
  }
}
