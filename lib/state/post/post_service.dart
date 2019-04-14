import 'package:crust/models/post.dart';
import 'package:crust/services/toaster.dart';
import 'package:crust/utils/enum_util.dart';

class PostService {
  const PostService();

  static Future<bool> deletePost(int postId, int myId) async {
    String query = """
      mutation {
        deletePost(postId: $postId, myId: $myId) {
          id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deletePost'];
    if (json != null) {
      return json['id'] == postId;
    } else {
      throw Exception('Failed to deletePost');
    }
  }

  static Future<Post> submitReviewPost(Post post) async {
    var body = post.postReview.body != null ? "${post.postReview.body}" : null;
    String query = """
      mutation {
        addReviewPost(
          storeId: ${post.store.id},
          body: $body,
          overallScore: ${EnumUtil.format(post.postReview.overallScore.toString())},
          tasteScore: ${EnumUtil.format(post.postReview.tasteScore.toString())},
          serviceScore: ${EnumUtil.format(post.postReview.serviceScore.toString())},
          valueScore: ${EnumUtil.format(post.postReview.valueScore.toString())},
          ambienceScore: ${EnumUtil.format(post.postReview.ambienceScore.toString())},
          photos: [${post.postPhotos.map((p) => '"$p"').join(", ")}],
          postedById: ${post.postedBy.id}
        ) {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addReviewPost'];
    if (json != null) {
      return Post.fromToaster(json);
    } else {
      throw Exception('Failed to submitReviewPost');
    }
  }

  Future<List<Post>> fetchPostsByUserId(int userId) async {
    String query = """
    query {
      postsByUserId(userId: $userId) {
        ${Post.attributes}
      }
    }
  """;
    final response = await Toaster.get(query);
    var json = response['postsByUserId'];
    if (json != null) {
      return (json as List).map((p) => Post.fromToaster(p)).toList();
    } else {
      throw Exception('Failed to fetchPostsByUserId');
    }
  }
}
