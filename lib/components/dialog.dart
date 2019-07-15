import 'package:crust/presentation/theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogOption {
  final String display;
  final Function onTap;
  final TextStyle style;

  DialogOption({this.display, this.onTap, this.style});
}

class BurntDialog extends StatelessWidget {
  final List<DialogOption> options;
  final String title;
  final String description;

  BurntDialog({Key key, this.options, this.title, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      if (title != null || description != null) _leading(context),
      if (options != null) _options(context),
    ];
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      content: Container(
        width: 100.0,
        child: Column(mainAxisSize: MainAxisSize.min, children: children)
      )
    );
  }

  Widget _leading(BuildContext context) {
    var children = <Widget>[
      if (title != null) Text(title, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
      if (title != null && description != null) Container(height: 5.0),
      if (description != null) Container(width: 200.0, child: Text(description, textAlign: TextAlign.center, style: TextStyle(color: Color(0xAA604B41), fontSize: 16.0))),
    ];
    return Container(
      padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Column(children: children)
    );
  }

  Widget _options(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      itemBuilder: (context, index) => _option(options[index]),
      separatorBuilder: (context, index) => Divider(color: Color(0x16007AFF)),
      itemCount: options.length);
  }

  Widget _option(DialogOption option) {
    return InkWell(
      splashColor: Colors.black12,
      child: Container(
        height: 40.0,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[Text(option.display, style: TextStyle(color: Color(0xFF007AFF), fontSize: 17.0))],
        ),
      ),
      onTap: option.onTap);
  }
}
