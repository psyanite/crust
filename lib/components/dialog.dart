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
  final String text;

  BurntDialog({Key key, this.options, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        content: Container(
            width: 100.0,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) => _option(options[index]),
                separatorBuilder: (context, index) => Divider(
                      color: Color(0x16007AFF),
                    ),
                itemCount: options.length)));
  }

  Widget _option(DialogOption option) {
    return InkWell(
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
