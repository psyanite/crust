import 'package:crust/models/user.dart';
import 'package:crust/models/store.dart';
import 'package:crust/utils/enum_util.dart';

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

  factory Post.fromJson(Map<String, dynamic> post) {
    var store = post['store'];
    var postedBy = post['posted_by'];
    var postPhotos = post['post_photos'];
    var postReview = post['post_review'];
    return Post(
      id: post['id'],
      type: EnumUtil.fromString(PostType.values, post['type']),
      store: Store(
        id: store['id'],
        name: store['name'],
        coverImage: store['cover_image'],
      ),
      postedBy: User(
        id: postedBy['id'],
        username: postedBy['profile']['username'],
        displayName: postedBy['profile']['display_name'],
        profilePicture: postedBy['profile']['profile_picture'],
      ),
      postedAt: DateTime.parse(post['posted_at']),
      postPhotos: (postPhotos as List).map((postPhoto) => PostPhoto(
        id: postPhoto['id'],
        photo: postPhoto['photo'],
      )).toList(),
      postReview: postReview == null ? null : PostReview(
        id: postReview['id'],
        ambienceScore: EnumUtil.fromString(Score.values, postReview['ambience_score']),
        overallScore: EnumUtil.fromString(Score.values, postReview['overall_score']),
        serviceScore: EnumUtil.fromString(Score.values, postReview['service_score']),
        tasteScore: EnumUtil.fromString(Score.values, postReview['taste_score']),
        valueScore: EnumUtil.fromString(Score.values, postReview['value_score']),
        body: postReview['body'],
      ));
  }
}

class PostPhoto {
  final int id;
  final String photo;

  PostPhoto({this.id, this.photo});
}

class PostReview {
  final int id;
  final Score overallScore;
  final Score tasteScore;
  final Score serviceScore;
  final Score valueScore;
  final Score ambienceScore;
  final String body;

  PostReview({this.id, this.overallScore, this.tasteScore, this.serviceScore, this.valueScore, this.ambienceScore, this.body});
}

enum PostType { photo, review }

enum Score { bad, okay, good }
