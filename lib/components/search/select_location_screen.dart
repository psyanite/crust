import 'package:crust/models/search.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/search/search_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectLocationScreen extends StatefulWidget {
  final SearchLocationItem current;
  final Function selectLocation;

  SelectLocationScreen({Key key, this.current, this.selectLocation}) : super(key: key);

  @override
  SelectLocationScreenState createState() => SelectLocationScreenState();
}

class SelectLocationScreenState extends State<SelectLocationScreen> {
  String _query = '';
  TextEditingController _queryCtrl;

  @override
  initState() {
    super.initState();
    _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.current.name));
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
      _searchResults(context),
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
            Text('CHANGE LOCATION', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0))
          ],
        ),
      )),
    );
  }

  Widget _searchBar() {
    return SliverToBoxAdapter(
      child: TextField(
        onChanged: (text) {
          if (text.trim() != _query.trim()) setState(() => _query = text);
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
              }),
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _searchResults(BuildContext context) {
    var queryTerm = _query.trim().isEmpty ? 's' : _query.trim();
    return FutureBuilder<List<SearchLocationItem>>(
      future: SearchService.searchLocations(queryTerm),
      builder: (context, AsyncSnapshot<List<SearchLocationItem>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
          case ConnectionState.waiting:
            return LoadingSliver();
          case ConnectionState.done:
            if (snapshot.hasError) {
              return SliverCenter(child: Text('Oops! Something went wrong, please try again'));
            } else if (snapshot.data.length == 0) {
              return SliverCenter(child: Text("No Results Found"));
            }
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                return Builder(builder: (context) => _ResultCard(location: snapshot.data[i], selectLocation: widget.selectLocation));
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
  final SearchLocationItem location;
  final Function selectLocation;

  const _ResultCard({Key key, this.location, this.selectLocation}) : super(key: key);

  @override
  Widget build(BuildContext context) => InkWell(
      onTap: () {
        selectLocation(location);
        Navigator.pop(context);
      },
      child: Padding(
          padding: EdgeInsets.only(top: 10.0, right: 16.0, left: 16.0),
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(location.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                Text(location.description, style: TextStyle(fontSize: 18.0)),
                Container(height: 10.0)
              ],
            ),
          )));
}
