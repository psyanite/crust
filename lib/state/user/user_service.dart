import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/services/toaster.dart';

class UserService {
  const UserService();

  Future<User> fetchUserByUserId(int userId) async {
    String query = """
      query {
        userAccountById(id: $userId) {
          id,
          email,
          profile {
            profile_picture,
            preferred_name,
            username,
            tagline
          },
          posts {
            ${Post.attributes}
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    return User.fromToaster(json);
  }

  static Future<User> fetchUserByUsername(String username) async {
    String query = """
      query {
        userProfileByUsername(username: "$username") {
          user_id,
          profile_picture,
          preferred_name,
          username,
          tagline
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userProfileByUsername'];
    return User.fromProfileToaster(json);
  }
}
