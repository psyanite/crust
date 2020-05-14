import 'package:crust/components/screens/message_screen.dart';
import 'package:crust/components/common/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ReportMissingStoreScreen extends StatefulWidget {

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<ReportMissingStoreScreen> {
  String _storeName = '';
  String _description = '';
  bool _submitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _appBar(),
          _form(context),
        ],
      ),
    );
  }

  Widget _appBar() {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
        child: Container(
          padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(width: 50.0, height: 60.0),
                  Positioned(left: -12.0, child: BackArrow(color: Burnt.lightGrey)),
                ],
              ),
              Text('REPORT MISSING STORE', style: Burnt.appBarTitleStyle)
            ],
          ),
        ),
      ),
    );
  }

  Widget _form(context) {
    return SliverCenter(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 40.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'What\'s the name of the store?'),
              onChanged: (val) => setState(() => _storeName = val),
              style: TextStyle(fontSize: 18.0, color: Burnt.textBodyColor),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: TextField(
              decoration: InputDecoration(hintText: 'Where is it located and what kind of store is it?'),
              onChanged: (val) => setState(() => _description = val),
              style: TextStyle(fontSize: 18.0, color: Burnt.textBodyColor),
            ),
          ),
          Container(height: 20.0),
          _submitButton(context),
        ],
      )
    );
  }

  Widget _submitButton(context) {
    if (_submitting) {
      return Padding(
        padding: EdgeInsets.only(top: 18.0, right: 30.0, bottom: 20.0),
        child: SizedBox(width: 20.0, height: 20.0, child: CircularProgressIndicator()),
      );
    }
    return Builder(
      builder: (context) {
        return InkWell(
          onTap: () => _press(context),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2.0),
              gradient: Burnt.buttonGradient,
            ),
            child: Text('SUBMIT', style: TextStyle(fontSize: 16.0, color: Colors.white, letterSpacing: 3.0)),
          ),
        );
      }
    );
  }

  _press(context) async {
    this.setState(() => _submitting = true);

    FocusScope.of(context).requestFocus(new FocusNode());
    if (_storeName.trim().isEmpty || _description.trim().isEmpty) {
      snack(context, 'Oops! Both fields have to be filled in');
      this.setState(() => _submitting = false);
      return;
    }

    try {
      await launch(Utils.buildEmail('Missing Store Report', '${_storeName.trim()}<br><br>Description: ${_description.trim()}'));
    } catch (e) {
      snack(context, 'Oops an error has occurred');
      this.setState(() => _submitting = false);
      return;
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MessageScreen(message: 'Thanks for letting us know!')));
  }
}
