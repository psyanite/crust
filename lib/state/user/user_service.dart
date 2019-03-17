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
            username
          },
          posts {
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
          } 
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    if (json != null) {
      return User.fromToaster(json);
    } else {
      throw Exception('Failed to fetchUserByUserId');
    }
  }
}
