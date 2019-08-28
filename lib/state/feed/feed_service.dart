import 'package:crust/models/post.dart';
import 'package:crust/services/toaster.dart';

class FeedService {
  const FeedService();

  Future<List<Post>> fetchDefaultFeed({int limit, int offset}) async {
    String query = """
      query {
        feedByDefault(limit: $limit, offset: $offset) {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['feedByDefault'];
    if (json == null) return List<Post>();
    return (json as List).map((p) => Post.fromToaster(p)).toList();
  }

  Future<List<Post>> fetchFeed({int userId, int limit, int offset}) async {
    String query = """
      query {
        feedByUserId(userId: $userId, limit: $limit, offset: $offset) {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['feedByUserId'];
    if (json == null) return List<Post>();
    return (json as List).map((p) => Post.fromToaster(p)).toList();
  }
}
