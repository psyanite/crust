import 'package:crust/models/user.dart';
import 'package:crust/models/store.dart';
import 'package:crust/utils/enum_util.dart';

class Post {
  final int id;
  final PostType type;
  final Store store;
  final User postedBy;
  final DateTime postedAt;
  final List<String> postPhotos;
  final PostReview postReview;

  Post({this.id, this.type, this.store, this.postedBy, this.postedAt, this.postPhotos, this.postReview});

  Post copyWith({List<String> postPhotos}) {
    return Post(
      id: this.id,
      type: this.type,
      store: this.store,
      postedBy: this.postedBy,
      postedAt: this.postedAt,
      postPhotos: postPhotos ?? this.postPhotos,
      postReview: this.postReview,
    );
  }
  factory Post.fromToaster(Map<String, dynamic> post) {
    if (post == null) return null;
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
        displayName: postedBy['profile']['preferred_name'],
        profilePicture: postedBy['profile']['profile_picture'],
      ),
      postedAt: DateTime.parse(post['posted_at']),
      postPhotos: (postPhotos as List).map<String>((postPhoto) => postPhoto['photo']).toList(),
      postReview: postReview != null ? PostReview(
        id: postReview['id'],
        overallScore: EnumUtil.fromString(Score.values, postReview['overall_score']),
        body: postReview['body'],
      ) : null);
  }

  static const attributes = """
    id,
    type,
    store {
      id,
      name,
      cover_image,
    },
    posted_by {
      id,
      profile {
        username,
        preferred_name,
        profile_picture,
      }
    },
    posted_at,
    post_photos {
      id,
      photo,
    },
    post_review {
      id,
      overall_score,
      body,
    }
  """;

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
  final String body;
  final Score overallScore;
  final Score tasteScore;
  final Score serviceScore;
  final Score valueScore;
  final Score ambienceScore;

  PostReview({this.id, this.body, this.overallScore, this.tasteScore, this.serviceScore, this.valueScore, this.ambienceScore});
}

enum PostType { photo, review }

enum Score { bad, okay, good }
