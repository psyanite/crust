import 'package:crust/components/profile/profile_screen.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/user/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FindUserScreen extends StatefulWidget {
  final int myId;

  FindUserScreen({Key key, this.myId}) : super(key: key);

  @override
  _FindUserScreenState createState() => _FindUserScreenState();
}

class _FindUserScreenState extends State<FindUserScreen> {
  TextEditingController _queryCtrl = TextEditingController();
  bool _loading = false;
  bool _pristine = true;

  _search(BuildContext context) async {
    if (_queryCtrl.text.trim().isEmpty) {
      return;
    }
    this.setState(() {
      _pristine = false;
      _loading = true;
    });
    var result = await UserService.fetchUserByUsername(_queryCtrl.text);
    if (result?.id == widget.myId) result = null;
    if (result == null) {
      this.setState(() {
        _loading = false;
      });
    } else {
      this.setState(() {
        _loading = false;
        _pristine = true;
        _queryCtrl = TextEditingController.fromValue(TextEditingValue(text: ''));
      });
      Navigator.push(context, MaterialPageRoute(builder: (_) => ProfileScreen(userId: result.id)));
    }
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      SliverToBoxAdapter(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _searchBar(context),
            _buttons(context),
            _searchResults(),
          ],
        ),
      )
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
              ],
            ),
            Text('FIND USER', style: Burnt.appBarTitleStyle)
          ]),
        ),
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 300.0,
          padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
          child: TextField(
            controller: _queryCtrl,
            onSubmitted: (text) => _search(context),
            style: TextStyle(fontSize: 18.0),
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Find someone by their username',
              prefixIcon: Icon(CrustCons.search, color: Burnt.lightGrey, size: 18.0),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buttons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        InkWell(
          onTap: () => Navigator.pop(context),
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: Burnt.primary, width: 1.0), borderRadius: BorderRadius.circular(2.0)),
            padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
            child: Text('CANCEL', style: TextStyle(fontSize: 16.0, color: Burnt.primary, letterSpacing: 3.0)),
          ),
        ),
        Container(width: 8.0),
        InkWell(
          onTap: () => _search(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              gradient: Burnt.buttonGradient,
            ),
            child: Text('SUBMIT', style: TextStyle(fontSize: 16.0, color: Colors.white, letterSpacing: 3.0)),
          ),
        ),
      ]),
    );
  }

  Widget _searchResults() {
    if (_pristine == true) {
      return Container();
    }
    if (_loading == true) {
      return Container(padding: EdgeInsets.only(top: 10.0), child: LoadingCenter());
    }
    return Container(child: Text('Sorry, we couldn\'t find any users under that username'));
  }
}
