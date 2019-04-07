import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AsyncButton extends StatefulWidget {
  final Function onPressed;
  final String text;

  AsyncButton({Key key, this.onPressed, this.text}) : super(key: key);

  @override
  _AsyncButtonState createState() => _AsyncButtonState(onPressed: onPressed, text: text);
}

class _AsyncButtonState extends State<AsyncButton> {
  final Function onPressed;
  final String text;
  bool isLoading = false;

  _AsyncButtonState({this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: _doMagic,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(2.0)),
          gradient: LinearGradient(
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            stops: [0, 0.6, 1.0],
            colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
          )),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[_content()],
        ),
      ),
    );
  }

  Widget _content() {
    if (isLoading) {
      return Container(
        width: 25.0,
        height: 25.0,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white)
        ),
      );
    }
    else {
      return Text(text, style: TextStyle(fontSize: 20.0, color: Colors.white, letterSpacing: 3.0));
    }
  }

  _doMagic() async {
    setState(() { isLoading = true; });
    await onPressed();
    setState(() { isLoading = false; });
  }
}
