import 'dart:math';
import 'dart:typed_data';

import 'package:crust/components/screens/store_screen.dart';
import 'package:crust/main.dart';
import 'package:crust/models/post.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:multi_image_picker/asset.dart';
import 'package:tuple/tuple.dart';

class UploadOverlay extends StatefulWidget {
  final Post post;
  final Function fetchPostsByStoreId;
  final List<Asset> images;

  UploadOverlay({Key key, this.post, this.fetchPostsByStoreId, this.images}) : super(key: key);

  @override
  UploadOverlayState createState() => UploadOverlayState(post: post, fetchPostsByStoreId: fetchPostsByStoreId, images: images);
}

class UploadOverlayState extends State<UploadOverlay> {
  final Post post;
  final Function fetchPostsByStoreId;
  final List<Asset> images;
  String loadingText = "Processing your awesome photos…";
  String error;

  UploadOverlayState({this.post, this.fetchPostsByStoreId, this.images});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x99000000),
      body: Center(
        child: AlertDialog(content: _content()),
      ),
    );
  }

  Widget _content() {
    if (error != null) {
      Text(error);
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(height: 15.0),
        Container(
          width: 50.0,
          height: 50.0,
          child: CircularProgressIndicator(),
        ),
        Container(height: 20.0),
        Text(loadingText),
      ],
    );
  }

  @override
  initState() {
    super.initState();
    _submit();
  }

  Future<bool> _submit() async {
    List<String> photoStrings = [];
    if (images.isNotEmpty) {
      photoStrings = await _uploadPhotos();
    }

    var result = await PostService.submitReviewPost(post.copyWith(postPhotos: photoStrings));
    if (result == null) {
      setState(() {
        error = "Oops! Something went wrong, please try again";
      });
      return false;
    }
    fetchPostsByStoreId(post.store.id);
    Navigator.popUntil(context, ModalRoute.withName(MainRoutes.root));
    Navigator.push(context, MaterialPageRoute(builder: (_) => StoreScreen(storeId: post.store.id)));
    return true;
  }

  Future<List<String>> _uploadPhotos() async {
    String timestamp = "${DateTime.now().millisecondsSinceEpoch}";
    List<Uint8List> byteData = await Future.wait(images.map((a) => _getByteData(a)));
    List<Tuple2<StorageUploadTask, StorageReference>> tasks = byteData.map((bd) {
      String fileName = "$timestamp-${Random().nextInt(10000)}.jpg";
      StorageReference ref = FirebaseStorage.instance.ref().child("reviews/post-photos/$fileName");
      return Tuple2(ref.putData(bd, StorageMetadata(customMetadata: {'secret': 'firebase'})), ref);
    }).toList(growable: false);

    setState(() {
      loadingText = "Uploading photos to the cloud…";
    });

    List<String> photoUrls = [];
    var halfwayPoint = (tasks.length / 2).floor();
    var count = 1;
    await Future.forEach(tasks, (t) async {
      await t.item1.onComplete;
      if (count == halfwayPoint) {
        setState(() {
          loadingText = "Almost there now…";
        });
      }
      if (t.item1.isSuccessful) {
        photoUrls.add(await t.item2.getDownloadURL());
      }
      count += 1;
    });

    return photoUrls;
  }

  Future<Uint8List> _getByteData(Asset asset) async {
    ByteData byteData = await asset.requestOriginal();
    List<int> compressed = await FlutterImageCompress.compressWithList(
      byteData.buffer.asUint8List(),
      minWidth: 1080,
    );
    asset.release();
    return Uint8List.fromList(compressed);
  }

//  Future<ByteData> _getByteData(Asset asset) async {
//    int quality = 100;
//    ByteData byteData = await asset.requestOriginal();
//    int size = byteData.lengthInBytes;
//    int fileSizeKb = (size - (size % 1000)) ~/ 1000;
//    if (fileSizeKb > 20000) {
//      while (size > 500000 && quality > 0) {
//        byteData = await asset.requestOriginal(quality: quality);
//        size = byteData.lengthInBytes;
//        quality = quality - 10;
//      }
//    } else if (fileSizeKb > 6000) {
//      byteData = await asset.requestOriginal(quality: 20);
//    } else if (fileSizeKb > 4000) {
//      byteData = await asset.requestOriginal(quality: 30);
//    } else if (fileSizeKb > 2000) {
//      byteData = await asset.requestOriginal(quality: 60);
//    } else if (fileSizeKb > 500) {
//      byteData = await asset.requestOriginal(quality: 80);
//    } else {
//      byteData = await asset.requestOriginal(quality: 90);
//    }
//    return byteData;
//  }
}
