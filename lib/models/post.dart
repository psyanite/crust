import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';
import 'package:crust/utils/enum_util.dart';

class Post {
  final int id;
  final PostType type;
  final bool hidden;
  final Store store;
  final User postedBy;
  final DateTime postedAt;
  final List<PostPhoto> postPhotos;
  final PostReview postReview;
  final int likeCount;
  final int commentCount;

  Post({this.id, this.type, this.hidden, this.store, this.postedBy, this.postedAt, this.postPhotos, this.postReview, this.likeCount, this.commentCount});

  Post copyWith({List<PostPhoto> postPhotos}) {
    return Post(
      id: this.id,
      type: this.type,
      hidden: this.hidden,
      store: this.store,
      postedBy: this.postedBy,
      postedAt: this.postedAt,
      postPhotos: postPhotos ?? this.postPhotos,
      postReview: this.postReview,
      likeCount: this.likeCount,
      commentCount: this.commentCount,
    );
  }

  factory Post.fromToaster(Map<String, dynamic> post) {
    if (post == null) return null;
    var postPhotos = post['post_photos'];
    var postReview = post['post_review'];
    return Post(
        id: post['id'],
        type: EnumUtil.fromString(PostType.values, post['type']),
        hidden: post['hidden'],
        store: Store.fromToaster(post['store']),
        postedBy: User.fromProfileToaster(post['posted_by']),
        postedAt: DateTime.parse(post['posted_at']),
        postPhotos: (postPhotos as List).map<PostPhoto>((postPhoto) {
          return PostPhoto(id: postPhoto['id'], url: postPhoto['url']);
        }).toList(),
        postReview: postReview != null
            ? PostReview(
                id: postReview['id'],
                overallScore: EnumUtil.fromString(Score.values, postReview['overall_score']),
                tasteScore: EnumUtil.fromString(Score.values, postReview['taste_score']),
                serviceScore: EnumUtil.fromString(Score.values, postReview['service_score']),
                valueScore: EnumUtil.fromString(Score.values, postReview['value_score']),
                ambienceScore: EnumUtil.fromString(Score.values, postReview['ambience_score']),
                body: postReview['body'],
              )
            : null,
        likeCount: post['like_count'],
        commentCount: post['comment_count'],
    );
  }

  static const attributes = """
    id,
    type,
    hidden,
    store {
      id,
      name,
      cover_image,
      location {
        id,
        name,
      },
      suburb {
        id,
        name,
      },
      cuisines {
        id,
        name,
      },
    },
    posted_by {
      user_id,
      username,
      preferred_name,
      profile_picture,
    },
    posted_at,
    post_photos {
      id,
      url,
    },
    post_review {
      id,
      overall_score,
      taste_score,
      service_score,
      value_score,
      ambience_score,
      body,
    },
    like_count,
    comment_count
  """;

  @override
  String toString() {
    return '{ id: $id, type: $type, store: ${store.name}, postedBy: ${postedBy.displayName} }';
  }
}

class PostPhoto {
  final int id;
  final String url;

  PostPhoto({this.id, this.url});
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
