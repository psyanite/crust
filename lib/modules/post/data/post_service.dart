import 'package:crust/models/Post.dart';
import 'package:crust/services/toaster.dart';

class PostService {
  const PostService();

  Future<List<Post>> fetchPostsByUserAccountId(int userAccountId) async {
    String query = """
    query {
      postsByUserAccountId(userAccountId: $userAccountId) {
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
    var json = response['postsByUserAccountId'];
    if (json != null) {
      return (json as List).map((p) => Post.fromToaster(p)).toList();
    } else {
      throw Exception('Failed to fetchPostsByUserAccountId');
    }
  }
}
