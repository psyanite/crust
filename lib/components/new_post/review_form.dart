import 'package:crust/components/new_post/photo_selector.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class ReviewForm extends StatelessWidget {
  final MyStore.Store store;

  ReviewForm({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        converter: (Store<AppState> store) => _Props.fromStore(store),
        builder: (BuildContext context, _Props props) => _Presenter(
              isLoggedIn: props.isLoggedIn,
              store: store,
            ));
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final MyStore.Store store;

  _Presenter({Key key, this.isLoggedIn, this.store}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(store: store);
}

class _PresenterState extends State<_Presenter> {
  MyStore.Store store;
  String query = '';
  Score overallScore;
  Score tasteScore;
  Score serviceScore;
  Score valueScore;
  Score ambienceScore;
  String reviewBody;

  _PresenterState({this.store});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _appBar(),
          _content(),
        ],
      ),
    );
  }

  Widget _appBar() {
    return Container(
      padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 40.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('WRITE A REVIEW', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
              Container(height: 50, width: 50),
            ],
          ),
          Text('for', style: TextStyle(fontSize: 20.0)),
          Container(height: 15.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                  width: 60.0,
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Burnt.imgPlaceholderColor,
                    image: DecorationImage(
                      image: NetworkImage(store.coverImage),
                      fit: BoxFit.cover,
                    ),
                  )),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(store.name, style: TextStyle(fontSize: 18.0, fontWeight: Burnt.fontBold)),
                    Text(store.location != null ? store.location : store.suburb, style: TextStyle(fontSize: 14.0)),
                    Text(store.cuisines.join(', '), style: TextStyle(fontSize: 14.0)),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _content() {
    Function selectPhotos = (photos) {
      setState(() {
        // todo: set photo data for upload
      });
    };
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(children: <Widget>[
            _overallQuestion(),
            _tasteQuestion(),
            _serviceQuestion(),
            _valueQuestion(),
            _ambienceQuestion(),
            Padding(
              padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
              child: PhotoSelector(),
            ),
            Container(
              width: 300.0,
              padding: EdgeInsets.only(bottom: 30.0),
              child: TextField(
                onChanged: (text) {
                  setState(() {
                    reviewBody = text;
                  });
                },
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: 'Add your thoughts here',
                  hintStyle: TextStyle(color: Burnt.hintTextColor),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.lightGrey)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.primaryLight, width: 1.0)),
                ),
                textAlign: TextAlign.center,
              ),
            ),

          ]),
        ),
        BottomButton(text: 'SUBMIT', onPressed: () {}),
      ],
    );
  }

  Widget _toastQuestion(
    String question,
    Function onTap,
    Score currentScore,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(question, style: TextStyle(fontSize: 18.0)),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _toastButton(Score.bad, onTap, currentScore == Score.bad),
              _toastButton(Score.okay, onTap, currentScore == Score.okay),
              _toastButton(Score.good, onTap, currentScore == Score.good),
            ],
          )
        ],
      ),
    );
  }

  Widget _overallQuestion() {
    Function onTap = (Score score) {
      setState(() {
        overallScore = score;
      });
    };
    return _toastQuestion('How was it overall?', onTap, overallScore);
  }

  Widget _tasteQuestion() {
    Function onTap = (Score score) {
      setState(() {
        tasteScore = score;
      });
    };
    return _toastQuestion('Was it delicious?', onTap, tasteScore);
  }

  Widget _serviceQuestion() {
    Function onTap = (Score score) {
      setState(() {
        serviceScore = score;
      });
    };
    return _toastQuestion('How was the service?', onTap, serviceScore);
  }

  Widget _valueQuestion() {
    Function onTap = (Score score) {
      setState(() {
        valueScore = score;
      });
    };
    return _toastQuestion('Was it good value?', onTap, valueScore);
  }

  Widget _ambienceQuestion() {
    Function onTap = (Score score) {
      setState(() {
        ambienceScore = score;
      });
    };
    return _toastQuestion('How was the ambience?', onTap, ambienceScore);
  }

  Widget _toastButton(Score score, Function onTap, bool isSelected) {
    var opacity = isSelected ? 1.0 : 0.6;
    return InkWell(
        onTap: () => onTap(score),
        child: Container(
          key: UniqueKey(),
            padding: EdgeInsets.all(10.0), child: ScoreIcon(opacity: opacity, score: score, size: 50.0)),
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent);
  }

  void _validate() {
    // todo: validate
    if (overallScore == null) {
      return;
    }
    if (tasteScore == null) {
      return;
    }
    if (serviceScore == null) {
      return;
    }
    if (valueScore == null) {
      return;
    }
    if (ambienceScore == null) {
      return;
    }
    if (reviewBody.isEmpty) {
      // todo: if reviewBody.isEmpty and no photos are selected
      return;
    }
  }

  void _uploadPhotos() {
    // todo: upload photos
    // https://stackoverflow.com/questions/44841729/how-to-upload-image-in-flutter
    // https://medium.com/@samuelomole/upload-images-to-a-rest-api-with-flutter-7ec1c447ff0e
  }
}

class _Props {
  final bool isLoggedIn;

  _Props({
    this.isLoggedIn,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
    );
  }
}
