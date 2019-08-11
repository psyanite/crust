import 'package:barcode_scan/barcode_scan.dart';
import 'package:crust/components/rewards/reward_screen.dart';
import 'package:crust/components/profile/profile_screen.dart';
import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/state/reward/reward_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ScanQrScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ScanQrScreenState();
}

// https://burntoast.page.link/?link=https://burntoast.com/stores/?id=1
// https://burntoast.page.link/?link=https://burntoast.com/profiles/?id=1
// https://burntoast.page.link/?link=https://burntoast.com/rewards/?code=4pPfr
// https://burntoast.page.link/?link=https://burntoast.com/rewards/?code=BKKWL
class ScanQrScreenState extends State<ScanQrScreen> {
  String error;

  @override
  initState() {
    super.initState();
    _load();
  }

  _load() async {
    var scanResult = await _scan();
    if (scanResult == null) return;

    var link = _parseScanResult(scanResult);
    if (link == null) return;

    var validateHost = _validateHost(link);
    if (validateHost == false) return;

    _parseLink(link);
  }

  _scan() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result != null) {
        return result;
      } else {
        this.setState(() => error = 'Oops, an error has occurred');
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this.setState(() => error = 'Sorry, looks like camera access is disabled.');
      } else {
        this.setState(() => error = 'Sorry, an unknown error has occurred.');
      }
    } on FormatException {
      // Back button is pressed
      Navigator.pop(context);
    } catch (e) {
      this.setState(() => error = 'Sorry, an unknown error has occurred.');
    }
    return null;
  }

  _parseScanResult(scanResult) {
    try {
      var uri = Uri.parse(scanResult);
      return Uri.parse(uri.queryParameters['link']);
    } on FormatException {
      this.setState(() => error = 'Sorry, an unknown error has occurred.');
    } on Exception {
      this.setState(() => error = 'Sorry, an unknown error has occurred.');
    }
    return null;
  }

  _validateHost(Uri link) {
    var host = link.host;
    if (host != 'burntoast.com') {
      this.setState(() => error = 'Sorry, we couldn\'t recognise this QR code.');
      return false;
    }
    return true;
  }

  _parseLink(Uri link) async {
    var path = link.path;
    var params = link.queryParameters;
    var idParam = params['id'];
    var id = idParam != null ? int.parse(idParam) : null;
    
    if (path == '/stores/') {
      if (id != null) {
        _redirect(StoreScreen(storeId: id));
      } else {
        this.setState(() => error = '/stores id param is invalid');
      }

    } else if (path == '/rewards/') {
      var code = params['code'];
      if (code != null) {
        var reward = await RewardService.fetchRewardByCode(code);
        if (reward != null) {
          _redirect(RewardScreen(reward: reward, rewardId: reward.id));
        } else {
          this.setState(() => error = 'Sorry, it looks like this reward has expired.');
        }
      } else {
        this.setState(() => error = '/rewards code param is invalid');
      }

    } else if (path == '/profiles/') {
      if (id != null) {
        _redirect(ProfileScreen(userId: id));
      } else {
        this.setState(() => error = '/profiles id param is invalid');
      }

    } else {
      this.setState(() => error = 'Sorry, we couldn\'t recognise this QR code.');
    }
  }

  _redirect(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    if (error == null) return Scaffold(body: LoadingCenter());
    return Scaffold(body: Center(
      child:
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
        Text(error),
        Container(height: 20.0),
        SmallButton(
          onPressed: () {
            this.setState(() => error = null);
            _load();
          },
          padding: EdgeInsets.only(left: 12.0, right: 12.0, top: 10.0, bottom: 10.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text('Try Again', style: TextStyle(fontSize: 16.0, color: Colors.white))
            ]))
        ],
      )
    ));
  }
}
