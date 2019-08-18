import 'package:crust/models/post.dart';
import 'package:crust/services/toaster.dart';

class FeedService {
  const FeedService();

  Future<Set<Post>> fetchDefaultFeed() async {
    String query = """
      query {
        feedByDefault {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['feedByDefault'];
    if (json == null) return Set<Post>();
    return (json as List).map((p) => Post.fromToaster(p)).toSet();
  }

  Future<Set<Post>> fetchFeed(int userId) async {
    String query = """
      query {
        feedByUserId(userId: $userId) {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['feedByUserId'];
    if (json == null) return Set<Post>();
    return (json as List).map((p) => Post.fromToaster(p)).toSet();
  }
}
