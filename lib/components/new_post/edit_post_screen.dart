import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:crust/components/new_post/photo_selector.dart';
import 'package:crust/components/new_post/upload_overlay.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart' as MyStore;
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/store/store_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:redux/redux.dart';

class EditPostScreen extends StatelessWidget {
  final Post post;

  EditPostScreen({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
      converter: (Store<AppState> store) => _Props.fromStore(store),
      builder: (BuildContext context, _Props props) =>
        _Presenter(
          post: post,
          fetchPostsByStoreId: props.fetchPostsByStoreId,
        ));
  }
}

class _Presenter extends StatefulWidget {
  final Post post;
  final Function fetchPostsByStoreId;

  _Presenter({Key key, this.post, this.fetchPostsByStoreId}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(currentPost: post, fetchPostsByStoreId: fetchPostsByStoreId);
}

class _PresenterState extends State<_Presenter> {
  final Post currentPost;
  final Function fetchPostsByStoreId;
  MyStore.Store store;
  Post post;
  Score overallScore;
  Score tasteScore;
  Score serviceScore;
  Score valueScore;
  Score ambienceScore;
  String reviewBody;
  List<String> currentImages;
  List<Asset> images = List<Asset>();
  List<Uint8List> imageData = List<Uint8List>();
  bool showOverlay = false;

  _PresenterState({this.currentPost, this.fetchPostsByStoreId});

  @override
  initState() {
    super.initState();
    store = currentPost.store;
    overallScore = currentPost.postReview.overallScore;
    tasteScore = currentPost.postReview.tasteScore;
    serviceScore = currentPost.postReview.serviceScore;
    valueScore = currentPost.postReview.valueScore;
    ambienceScore = currentPost.postReview.ambienceScore;
    reviewBody = currentPost.postReview.body;
    currentImages = currentPost.postPhotos;
  }

  @override
  Widget build(BuildContext context) {
    var children = <Widget>[
      Scaffold(
        body: ListView(
          children: <Widget>[
            _appBar(),
            _content(),
          ],
        ),
      )
    ];
    if (showOverlay) {
      children.add(
        UploadOverlay(post: post, fetchPostsByStoreId: fetchPostsByStoreId, images: images)
      );
    }
    return Stack(
      fit: StackFit.expand,
      children: children,
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
              Text('EDIT REVIEW', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
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
    Function(List<Asset>) onSelectImages = (photos) {
      setState(() {
        images = photos;
        imageData = List.generate(photos.length, (i) => null, growable: false);
      });
      _loadImages(photos);
    };
    return Builder(
      builder: (context) =>
        Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(children: <Widget>[
                _overallQuestion(),
                _tasteQuestion(),
                _serviceQuestion(),
                _valueQuestion(),
                _ambienceQuestion(),
                _currentImages(),
                Padding(
                  padding: EdgeInsets.only(top: 20.0, bottom: 30.0),
                  child: PhotoSelector(images: imageData, onSelectImages: onSelectImages),
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
            _submitButton(context),
          ],
        ),
    );
  }

  Widget _toastQuestion(String question,
    Function onTap,
    Score currentScore,) {
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
      highlightColor: Colors.transparent);
  }

  Widget _currentImages() {
    if (currentImages.isEmpty) return Container();
    final List<Widget> images = post.postPhotos
      .map<Widget>((image) => CachedNetworkImage(
      imageUrl: image,
      fit: BoxFit.cover,
      fadeInDuration: Duration(milliseconds: 100),
    )).toList(growable: false);
    return Row(
      children: images,
    );

  }

  bool _isValid(BuildContext context) {
    if (overallScore == null) {
      snack(context, "Select a toast for how it was all over");
      return false;
    }
    if (tasteScore == null) {
      snack(context, "Select a toast for whether it was delicious");
      return false;
    }
    if (serviceScore == null) {
      snack(context, "Select a toast for how the service was");
      return false;
    }
    if (valueScore == null) {
      snack(context, "Select a toast for whether it was good value");
      return false;
    }
    if (ambienceScore == null) {
      snack(context, "Select a toast for how the ambience was");
      return false;
    }
    if ((reviewBody == null || reviewBody.isEmpty) && images.isEmpty) {
      snack(context, "Add some photos or add some thoughts");
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
        return "Oops! The photo is larger than 5000x5000";
      } else {
        return "Oops! One of the photos is larger than 5000x5000";
      }
    }
    return null;
  }

  Future<void> _submit(BuildContext context) async {
    if (!_isValid(context)) return false;

    var newPost = Post(
      id: currentPost.id,
      type: PostType.review,
      store: store,
      postPhotos: [],
      postReview: PostReview(
        body: reviewBody,
        overallScore: overallScore,
        tasteScore: tasteScore,
        serviceScore: serviceScore,
        valueScore: valueScore,
        ambienceScore: ambienceScore),
    );

    setState(() {
      post = newPost;
      showOverlay = true;
    });
  }

  _submitButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _submit(context);
      },
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
          children: <Widget>[Text('SUBMIT', style: TextStyle(fontSize: 20.0, color: Colors.white, letterSpacing: 3.0))],
        ),
      ),
    );
  }

  _loadImages(photos) async {
    images.asMap().forEach((i, image) async {
      await image.requestOriginal(quality: 80);
      imageData[i] = image.imageData.buffer.asUint8List();
      setState(() {
        imageData = imageData;
      });
    });
  }
}

class _Props {
  final Function fetchPostsByStoreId;

  _Props({
    this.fetchPostsByStoreId,
  });

  static fromStore(Store<AppState> store) {
    return _Props(
      fetchPostsByStoreId: (storeId) => store.dispatch(FetchPostsByStoreIdRequest(storeId)),
    );
  }
}
