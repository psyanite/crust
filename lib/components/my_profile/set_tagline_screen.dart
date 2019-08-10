import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/me/me_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class SetTaglineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(
      onInit: (Store<AppState> store) => store.dispatch(FetchMyPostsRequest(store.state.me.user.id)),
      converter: _Props.fromStore,
      builder: (context, props) {
        return _Presenter(tagline: props.tagline, setTagline: props.setTagline, deleteTagline: props.deleteTagline);
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final String tagline;
  final Function setTagline;
  final Function deleteTagline;

  _Presenter({Key key, this.tagline, this.setTagline, this.deleteTagline}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  TextEditingController _taglineCtrl = TextEditingController();

  @override
  initState() {
    super.initState();
    if (widget.tagline != null) _taglineCtrl = TextEditingController.fromValue(TextEditingValue(text: widget.tagline));
  }

  @override
  dispose() {
    _taglineCtrl.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    var tagline = _taglineCtrl.text;
    if (tagline.isNotEmpty && tagline.length > 64) {
      snack(context, 'Tagline can\'t be more than 64 characters long');
      return;
    }
    if (tagline.isEmpty) {
      widget.deleteTagline();
    } else {
      widget.setTagline(tagline);
    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(),
      _form(context),
    ];
    return Scaffold(body: CustomScrollView(slivers: slivers));
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
            Text('SET TAGLINE', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0))
          ],
        ),
      )),
    );
  }

  Widget _form(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 300.0,
            padding: EdgeInsets.only(bottom: 30.0),
            child: TextField(
              autofocus: true,
              controller: _taglineCtrl,
              decoration: InputDecoration(
                hintText: 'Add your tagline here',
                hintStyle: TextStyle(color: Burnt.hintTextColor),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.lightGrey)),
                focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.primaryLight, width: 1.0)),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buttons(context),
          Container(height: 50.0),
        ],
      ),
    );
  }

  Widget _buttons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.pop(context),
            child: Container(
              decoration: BoxDecoration(
                  border: Border.all(
                    color: Burnt.primary,
                    width: 1.0,
                  ),
                  borderRadius: BorderRadius.circular(2.0)),
              padding: EdgeInsets.symmetric(vertical: 11.0, horizontal: 16.0),
              child: Text('CANCEL', style: TextStyle(fontSize: 16.0, color: Burnt.primary, letterSpacing: 3.0)),
            ),
          ),
          Container(width: 8.0),
          InkWell(
            onTap: () => _submit(context),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.0),
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    stops: [0, 0.6, 1.0],
                    colors: [Color(0xFFFFAB40), Color(0xFFFFAB40), Color(0xFFFFC86B)],
                  )),
              child: Text('SUBMIT', style: TextStyle(fontSize: 16.0, color: Colors.white, letterSpacing: 3.0)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Props {
  final String tagline;
  final Function setTagline;
  final Function deleteTagline;

  _Props({this.tagline, this.setTagline, this.deleteTagline});

  static fromStore(Store<AppState> store) {
    return _Props(
      tagline: store.state.me.user?.tagline,
      setTagline: (tagline) => store.dispatch(SetMyTagline(tagline)),
      deleteTagline: () => store.dispatch(DeleteMyTagline()),
    );
  }
}
