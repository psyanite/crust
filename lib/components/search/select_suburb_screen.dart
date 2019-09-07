import 'package:async/async.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SelectSuburbScreen extends StatefulWidget {
  final Function selectLocation;

  SelectSuburbScreen({Key key, this.selectLocation}) : super(key: key);

  @override
  SelectSuburbScreenState createState() => SelectSuburbScreenState();
}

class SelectSuburbScreenState extends State<SelectSuburbScreen> {
  final AsyncMemoizer<List<MyStore.Suburb>> _memo = AsyncMemoizer();
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
    return StoreConnector<AppState, dynamic>(
      converter: (Store<AppState> store) => store.state.me.suburb,
      builder: (context, suburb) {
        var slivers = <Widget>[
          _appBar(),
          _searchBar(),
          if (suburb != null) _calculatedItem(suburb),
          _searchResults(context),
        ];
        return Scaffold(body: CustomScrollView(slivers: slivers));
      },
    );
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
      )),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: TextField(
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

  Widget _calculatedItem(MyStore.Suburb s) {
    return SliverToBoxAdapter(
      child: InkWell(
        onTap: () {
          widget.selectLocation(s);
          Navigator.pop(context);
        },
        child: Container(
          padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(s.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
              Text('${s.city}, ${s.district}', style: TextStyle(fontSize: 18.0)),
              Container(height: 10.0)
            ],
          ),
        ),
      ),
    );
  }

  Future<List<MyStore.Suburb>> _search() {
    return _memo.runOnce(() async {
      return await SearchService.findSuburbsBySearch(_query.isEmpty ? 's' : _query);
    });
  }

  Widget _searchResults(BuildContext context) {
    return FutureBuilder(
      future: _search(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliverCenter();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return SliverCenter(child: Text('Oops! Something went wrong, please try again'));
            } else if (snapshot.data.length == 0) {
              return SliverCenter(child: Text("No Results Found"));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) => _ResultCard(suburb: snapshot.data[i], select: widget.selectLocation));
              }, childCount: snapshot.data.length),
            );
          default:
            return SliverCenter(child: Container());
        }
      },
    );
  }
}

class _ResultCard extends StatelessWidget {
  final MyStore.Suburb suburb;
  final Function select;

  const _ResultCard({Key key, this.suburb, this.select}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        select(suburb);
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(suburb.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
            Text('${suburb.city}, ${suburb.district}', style: TextStyle(fontSize: 18.0)),
            Container(height: 10.0)
          ],
        ),
      ),
    );
  }
}
