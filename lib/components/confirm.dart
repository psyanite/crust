import 'package:crust/components/dialog.dart';
import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Confirm extends StatelessWidget {
  final String title;
  final String description;
  final String action;
  final Function onTap;

  Confirm({Key key, this.title, this.description, this.action, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var options = <DialogOption>[
      DialogOption(display: action, onTap: onTap, style: TextStyle(color: Color(0xFF51a4ff), fontSize: 16.0, fontWeight: Burnt.fontBold)),
      DialogOption(display: 'Cancel', onTap: () => Navigator.of(context, rootNavigator: true).pop(true), style: TextStyle(fontSize: 16.0)),
    ];
    return AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        content: Container(
            width: 100,
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Container(
                  padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                  child: Column(children: <Widget>[
                    Text(title, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Container(height: 5.0),
                    Container(width: 200.0, child: Text(description, textAlign: TextAlign.center, style: TextStyle(color: Color(0xAA604B41), fontSize: 14.0))),
                  ])),
              Container(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: List<Widget>.from(options.map((o) => Column(children: <Widget>[
                        Divider(
                          color: Color(0x16007AFF),
                        ),
                        _option(o)
                      ]))),
                ),
              ),
            ])));
  }

  Widget _option(DialogOption option) {
    return InkWell(
        child: Container(
          height: 40.0,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[Text(option.display, style: option.style)],
          ),
        ),
        onTap: option.onTap);
  }
}
