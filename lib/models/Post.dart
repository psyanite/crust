import 'package:crust/models/user.dart';
import 'package:crust/models/store.dart';

class Post {
  final int id;
  final PostType type;
  final Store store;
  final User postedBy;
  final DateTime postedAt;
  final List<PostPhoto> postPhotos;
  final PostReview postReview;

  Post({this.id, this.type, this.store, this.postedBy, this.postedAt, this.postPhotos, this.postReview});

  @override
  String toString() {
    return '{ id: $id, type: $type, store: ${store.name}, postedBy: ${postedBy.displayName} }';
  }
}

class PostPhoto {
  final int id;
  final String photo;

  PostPhoto({this.id, this.photo});
}

class PostReview {
  final int id;
  final Score tasteScore;
  final Score serviceScore;
  final Score valueScore;
  final Score ambienceScore;
  final String body;

  PostReview({this.id, this.tasteScore, this.serviceScore, this.valueScore, this.ambienceScore, this.body});
}

enum PostType { photo, review }

enum Score { bad, okay, good }

