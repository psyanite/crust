import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class UseMyLocation extends StatefulWidget {
  @override
  UseMyLocationState createState() => UseMyLocationState();
}

class UseMyLocationState extends State<UseMyLocation> {
  bool _loadingLocation;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Function>(
      converter: (Store<AppState> store) => (address) => store.dispatch(SetMyAddress(address)),
      builder: (context, setMyAddress) {
        return InkWell(
          onTap: () => _getLocation(context, setMyAddress),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
            child: _loadingLocation == true
                ? Container(
                    width: 100.0,
                    child: Center(child: Container(width: 20.0, height: 20.0, child: CircularProgressIndicator(strokeWidth: 3.0))))
                : Text('Use My Location', style: TextStyle(color: Burnt.primaryTextColor)),
          ),
        );
      },
    );
  }

  _getLocation(context, setMyAddress) async {
    var enabled = await Geolocator().isLocationServiceEnabled();
    if (enabled == false) {
      snack(context, 'Oops! Looks like your device location is not turned on');
      return;
    }
    this.setState(() => _loadingLocation = true);
    var address = await Utils.getGeoAddress(10);
    if (address != null) setMyAddress(address);
  }
}

class MyLocation extends StatefulWidget {
  final Function onTap;

  MyLocation({Key key, this.onTap}) : super(key: key);

  @override
  MyLocationState createState() => MyLocationState();
}

class MyLocationState extends State<MyLocation> {
  bool _initialising = true;
  bool _loading = false;
  Address _address;

  @override
  initState() {
    super.initState();
    _load();
  }

  _load() async {
    var enabled = await Geolocator().isLocationServiceEnabled();
    if (enabled == true) {
      var address = await Utils.getGeoAddress(10);
      if (address != null) this.setState(() => _address = address);
    }
    this.setState(() => _initialising = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_initialising == true) return Container();
    if (_loading == true)
      Container(
          width: 100.0, child: Center(child: Container(width: 20.0, height: 20.0, child: CircularProgressIndicator(strokeWidth: 3.0))));
    if (_address == null) {
      return InkWell(
        onTap: () => _getLocation(context),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: Text('Use My Location', style: TextStyle(color: Burnt.primaryTextColor)),
        ),
      );
    }
    return InkWell(
      onTap: () => widget.onTap(_address),
      child: Container(
        padding: EdgeInsets.only(top: 10.0, right: 2.0, left: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(_address.addressLine.split(',')[0] ?? '', style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
            Text(_address.locality ?? '', style: TextStyle(fontSize: 18.0)),
            Container(height: 10.0)
          ],
        ),
      ),
    );
  }

  _getLocation(context) async {
    var enabled = await Geolocator().isLocationServiceEnabled();
    if (enabled == false) {
      snack(context, 'Oops! Looks like your device location is not turned on');
      return;
    }
    this.setState(() => _loading = true);
    var address = await Utils.getGeoAddress(10);
    if (address != null) this.setState(() => _address = address);
    this.setState(() => _loading = false);
  }
}
