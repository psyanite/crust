import 'package:crust/models/user.dart';
import 'package:crust/services/toaster.dart';
import 'package:crust/utils/enum_util.dart';

class MeService {
  const MeService();

  static Future<int> getUserAccountIdByUsername(String username) async {
    String getUserAccountIdByUsername = """
      query {
        userProfileByUsername(username: "$username") {
          user_account {
            id
          }
        }
      }
    """;
    final response = await Toaster.get(getUserAccountIdByUsername);
    if (response['userProfileByUsername'] != null) {
      return response['userProfileByUsername']['user_account']['id'];
    } else {
      return null;
    }
  }

  static Future<User> getUser(User user) async {
    String getUserLogin = """
      query {
        userLoginBy(
          socialType: "${EnumUtil.toString(user.socialType.toString())}", 
          socialId: "${user.socialId}"
          ) {
          user_account {
            id,
            profile {
              profile_picture,
              display_name,
              username
            }
          }
        }
      }
    """;
    final response = await Toaster.get(getUserLogin);
    if (response['userLoginBy'] != null) {
      return user.copyWith(
        id: response['userLoginBy']['user_account']['id'],
        profilePicture: response['userLoginBy']['user_account']['profile']['profile_picture'],
        displayName: response['userLoginBy']['user_account']['profile']['display_name'],
        username: response['userLoginBy']['user_account']['profile']['username']
      );
    } else {
      return null;
    }
  }

  Future<int> addUser(User user) async {
    String addUser = """
    mutation {
      addUser(
        username: "${user.username}",
        display_name: "${user.displayName}",
        email: "${user.email}",
        profile_picture: "${user.profilePicture}",
        social_id: "${user.socialId}",
        social_type: "${EnumUtil.toString(user.socialType.toString())}"
      ) {
        user_account {
          id
        }
      }
    }
  """;
    final response = await Toaster.get(addUser);
    if (response['addUser'] != null) {
      return response['addUser']['user_account']['id'];
    } else {
      throw Exception('Failed');
    }
  }
}
