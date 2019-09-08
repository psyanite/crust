import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:redux/redux.dart';

class UseMyLocation extends StatefulWidget {
  final Function selectLocation;

  UseMyLocation({Key key, this.selectLocation}) : super(key: key);

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
              : Text("Use My Location", style: TextStyle(color: Burnt.primaryTextColor)),
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
    var p = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high).timeout(Duration(seconds: 10));
    var addresses = await Geocoder.local.findAddressesFromCoordinates(Coordinates(p.latitude, p.longitude)).timeout(Duration(seconds: 10));
    if (addresses.isNotEmpty) {
      setMyAddress(addresses[0]);
    }
  }
}
