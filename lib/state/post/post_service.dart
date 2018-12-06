import 'package:crust/models/post.dart';
import 'package:crust/services/toaster.dart';

class PostService {
  const PostService();

  Future<List<Post>> fetchPostsByUserId(int userId) async {
    String query = """
    query {
      postsByUserId(userId: $userId) {
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
            display_name,
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
