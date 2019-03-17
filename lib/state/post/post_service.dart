import 'package:crust/models/post.dart';
import 'package:crust/services/toaster.dart';
import 'package:crust/utils/enum_util.dart';

class PostService {
  const PostService();

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
