import 'package:crust/components/dialog/dialog.dart';
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
    var content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 10.0),
        Column(children: <Widget>[
          Text(title, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
          if (description != null) _description(),
        ]),
        Container(height: 10.0),
        _options(context),
      ],
    );
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      content: Container(
        width: 100,
        child: content,
      ),
    );
  }

  Widget _description() {
    return Container(
      margin: EdgeInsets.only(top: 5.0),
      width: 200.0,
      child: Text(description, textAlign: TextAlign.center, style: TextStyle(color: Color(0xAA604B41), fontSize: 14.0)),
    );
  }

  Widget _options(context) {
    var options = <DialogOption>[
      DialogOption(display: action, onTap: onTap, style: TextStyle(color: Burnt.anchorColor, fontSize: 16.0, fontWeight: Burnt.fontBold)),
      DialogOption(display: 'Cancel', onTap: () => Navigator.of(context, rootNavigator: true).pop(true), style: TextStyle(fontSize: 16.0)),
    ];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.from(options.map((o) {
        return Column(children: <Widget>[Divider(color: Color(0x16007AFF)), _option(o)]);
      })),
    );
  }

  Widget _option(DialogOption option) {
    return InkWell(
      onTap: option.onTap,
      child: Container(
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(option.display, style: option.style)],
        ),
      ),
    );
  }
}
