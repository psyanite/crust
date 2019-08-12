import 'package:barcode_scan/barcode_scan.dart';
import 'package:crust/components/profile/profile_screen.dart';
import 'package:crust/components/rewards/reward_screen.dart';
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

/// Example URLs:
/// https://burntoast.page.link/?link=https://burntoast.com/stores/?id=1
/// https://burntoast.page.link/?link=https://burntoast.com/profiles/?id=1
/// https://burntoast.page.link/?link=https://burntoast.com/rewards/?code=4pPfr
/// https://burntoast.page.link/?link=https://burntoast.com/rewards/?code=BKKWL
///
/// Example secret codes:
/// :stores:1
/// :profiles:1
/// :rewards:4pPfr
/// :rewards:BKKWL
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

    if (scanResult.startsWith(':')) {
      _parseSecretString(scanResult);
    } else {
      _parseLink(scanResult);
    }
  }

  _scan() async {
    try {
      var result = await BarcodeScanner.scan();
      if (result != null) {
        return result;
      } else {
        _setError('4013');
      }
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _setError('4012');
      } else {
        _setError('4011');
      }
    } on FormatException {
      // Back button is pressed
      Navigator.pop(context);
    } catch (e) {
      _setError('4010');
    }
    return null;
  }

  /// Only accepts a string in the following format ":type:identifier".
  /// Type should be plural.
  /// Examples:
  /// :stores:1
  /// :profiles:1
  /// :rewards:code
  _parseSecretString(String scanResult) async {
    var parts = scanResult.split(':');
    if (parts.length != 3) {
      _setError('4009');
      return;
    }

    var identifier = parts[2];
    var id = int.tryParse(identifier);
    switch (parts[1]) {
      case 'stores':
        if (id == null) {
          _setError('4014');
          return;
        }
        _redirect(StoreScreen(storeId: id));
        break;
      case 'profiles':
        if (id == null) {
          _setError('4015');
          return;
        }
        _redirect(ProfileScreen(userId: id));
        break;
      case 'rewards':
        var reward = await RewardService.fetchRewardByCode(identifier);
        if (reward == null) {
          _setError('4016');
        }
        _redirect(RewardScreen(reward: reward, rewardId: reward.id));
        break;
    }

    _setError('4017');
  }

  _parseLink(String scanResult) async {
    var link = _parseScanResult(scanResult);
    if (link == null) return;

    var validateHost = _validateHost(link);
    if (validateHost == false) return;

    var path = link.path;
    var params = link.queryParameters;
    var idParam = params['id'];
    var id = idParam != null ? int.parse(idParam) : null;

    if (path == '/stores/') {
      if (id != null) {
        _redirect(StoreScreen(storeId: id));
      } else {
        _setError('4009');
      }
    } else if (path == '/rewards/') {
      var code = params['code'];
      if (code != null) {
        var reward = await RewardService.fetchRewardByCode(code);
        if (reward != null) {
          _redirect(RewardScreen(reward: reward, rewardId: reward.id));
        } else {
          _setError('4008');
        }
      } else {
        _setError('4007');
      }
    } else if (path == '/profiles/') {
      if (id != null) {
        _redirect(ProfileScreen(userId: id));
      } else {
        _setError('4006');
      }
    } else {
      _setError('4005');
    }
  }

  _parseScanResult(String scanResult) {
    try {
      var uri = Uri.parse(scanResult);
      return Uri.parse(uri.queryParameters['link']);
    } on FormatException {
      _setError('4002');
    } on Exception {
      _setError('4003');
    }
    return null;
  }

  _validateHost(Uri link) {
    var host = link.host;
    if (host != 'burntoast.com') {
      _setError('4001');
      return false;
    }
    return true;
  }

  _redirect(Widget screen) {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  _setError(String code) {
    this.setState(() => error = 'Sorry, we couldn\'t recognise this QR code, error $code occurred.');
  }

  @override
  Widget build(BuildContext context) {
    if (error == null) return Scaffold(body: LoadingCenter());
    return Scaffold(
      body: Center(
        child: Column(
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
                children: <Widget>[Text('Try Again', style: TextStyle(fontSize: 16.0, color: Colors.white))],
              ),
            )
          ],
        ),
      ),
    );
  }
}
