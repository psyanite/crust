import 'dart:typed_data';

import 'package:crust/components/dialog/dialog.dart';
import 'package:crust/components/photo/photo_selector.dart';
import 'package:crust/components/new_post/upload_overlay.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:redux/redux.dart';

class ReviewForm extends StatelessWidget {
  final MyStore.Store store;

  ReviewForm({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) {
        return _Presenter(
          isLoggedIn: props.isLoggedIn,
          me: props.me,
          store: store,
        );
      },
    );
  }
}

class _Presenter extends StatefulWidget {
  final bool isLoggedIn;
  final MyStore.Store store;
  final User me;

  _Presenter({Key key, this.isLoggedIn, this.store, this.me}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState();
}

class _PresenterState extends State<_Presenter> {
  Post post;
  Score overallScore;
  Score tasteScore;
  Score serviceScore;
  Score valueScore;
  Score ambienceScore;
  String reviewBody;
  bool makeSecret = false;
  List<Asset> images = List<Asset>();
  List<Uint8List> imageData = List<Uint8List>();
  bool showOverlay = false;

  _PresenterState();

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Scaffold(
          body: ListView(
            children: <Widget>[
              _appBar(),
              _content(),
            ],
          ),
        ),
        if (showOverlay) UploadOverlay(post: post, images: images)
      ],
    );
  }

  Widget _appBar() {
    var store = widget.store;
    return Container(
      padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 40.0, bottom: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text('WRITE A REVIEW', style: Burnt.appBarTitleStyle),
              Container(height: 50, width: 50),
            ],
          ),
          Text('for', style: TextStyle(fontSize: 20.0)),
          Container(height: 15.0),
          Row(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              NetworkImg(store.coverImage, width: 60.0, height: 50.0),
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
    Function(List<Asset>) onSelectImages = (photos) {
      setState(() {
        images = photos;
        imageData = List.generate(photos.length, (i) => null, growable: false);
      });
      _loadImages(photos);
    };
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(children: <Widget>[
              _overallQuestion(),
              _tasteQuestion(),
              _serviceQuestion(),
              _valueQuestion(),
              _ambienceQuestion(),
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
                child: PhotoSelector(images: imageData, onSelectImages: onSelectImages),
              ),
              _reviewBody(),
              _secretSwitch(context),
            ]),
          ),
          _buttons(context),
        ],
      );
    });
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
      child: Container(key: UniqueKey(), padding: EdgeInsets.all(10.0), child: ScoreIcon(opacity: opacity, score: score, size: 50.0)),
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
    );
  }

  Widget _reviewBody() {
    return Container(
      width: 300.0,
      padding: EdgeInsets.only(bottom: 30.0),
      child: TextField(
        maxLines: null,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.multiline,
        onChanged: (text) => setState(() => reviewBody = text),
        decoration: InputDecoration(
          hintText: 'Add your thoughts here',
          hintStyle: TextStyle(color: Burnt.hintTextColor),
          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.lightGrey)),
          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Burnt.primaryLight, width: 1.0)),
        ),
      ),
    );
  }

  Widget _secretSwitch(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(makeSecret ? 'Keep Secret' : 'Make Public'),
          IconButton(icon: Icon(Icons.help_outline, color: Burnt.lightGrey), onPressed: () => _showSecretDialog(context)),
          CupertinoSwitch(
            value: !makeSecret,
            activeColor: Color(0xFF64D2FF),
            onChanged: (bool value) {
              setState(() => makeSecret = !value);
            },
          )
        ],
      ),
    );
  }

  _showSecretDialog(BuildContext context) {
    var options = <DialogOption>[DialogOption(display: 'OK', onTap: () => Navigator.of(context, rootNavigator: true).pop(true))];
    showDialog(
      context: context,
      builder: (context) {
        return BurntDialog(
          options: options,
          description:
              'Posting publically will allow anyone on Burntoast to see your review on the store page and your profile page.\n\nPosting secretly will only allow you to see your own review on your own profile page.',
        );
      },
    );
  }

  bool _isValid(BuildContext context) {
    if (overallScore == null) {
      snack(context, 'Select a toast for how it was overall');
      return false;
    }
    if (tasteScore == null) {
      snack(context, 'Select a toast for whether it was delicious');
      return false;
    }
    if (serviceScore == null) {
      snack(context, 'Select a toast for how the service was');
      return false;
    }
    if (valueScore == null) {
      snack(context, 'Select a toast for whether it was good value');
      return false;
    }
    if (ambienceScore == null) {
      snack(context, 'Select a toast for how the ambience was');
      return false;
    }
    if ((reviewBody == null || reviewBody.isEmpty) && images.isEmpty) {
      snack(context, 'Add some photos or add some thoughts');
      return false;
    }
    if (images.isNotEmpty) {
      var validatePhotos = _validatePhotos();
      if (validatePhotos != null) {
        snack(context, validatePhotos);
        return false;
      }
    }
    return true;
  }

  String _validatePhotos() {
    var isValid = true;
    images.forEach((a) {
      if (a.originalHeight > 5000 || a.originalWidth > 5000) {
        isValid = false;
        return;
      }
    });
    if (!isValid) {
      if (images.length == 1) {
        return 'Oops! Photo has to be smaller than 5000x5000';
      } else {
        return 'Oops! All the photos have to be smaller than 5000x5000';
      }
    }
    return null;
  }

  _submit(BuildContext context) async {
    if (!_isValid(context)) return false;

    var newPost = Post(
      type: PostType.review,
      hidden: makeSecret,
      store: widget.store,
      postPhotos: [],
      postReview: PostReview(
        body: reviewBody,
        overallScore: overallScore,
        tasteScore: tasteScore,
        serviceScore: serviceScore,
        valueScore: valueScore,
        ambienceScore: ambienceScore,
      ),
      postedBy: widget.me,
    );

    setState(() {
      post = newPost;
      showOverlay = true;
    });
  }

  Widget _buttons(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 30.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
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
              gradient: Burnt.buttonGradient,
            ),
            child: Text('SUBMIT', style: TextStyle(fontSize: 16.0, color: Colors.white, letterSpacing: 3.0)),
          ),
        ),
      ]),
    );
  }

  _loadImages(photos) async {
    images.asMap().forEach((i, image) async {
      var byteData = await image.getByteData(quality: 80);
      imageData[i] = byteData.buffer.asUint8List();
      setState(() {
        imageData = imageData;
      });
    });
  }
}

class _Props {
  final bool isLoggedIn;
  final User me;
  _Props({
    this.isLoggedIn,
    this.me,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      isLoggedIn: store.state.me.user != null,
      me: store.state.me.user,
    );
  }
}
