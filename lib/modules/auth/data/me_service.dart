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
    var json = response['userProfileByUsername'];
    if (json != null) {
      return json['user_account']['id'];
    } else {
      throw Exception('Failed to getUserAccountIdByUsername');
    }
  }

  static Future<User> getUser(User user) async {
    String getUserLogin = """
      query {
        userLoginBy(
          socialType: "${EnumUtil.format(user.socialType.toString())}", 
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
    var json = response['userLoginBy'];
    if (json != null) {
      return user.copyWith(
          id: json['user_account']['id'],
          profilePicture: json['user_account']['profile']['profile_picture'],
          displayName: json['user_account']['profile']['display_name'],
          username: json['user_account']['profile']['username']);
    } else {
      throw Exception('Failed to getUser');
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
          social_type: "${EnumUtil.format(user.socialType.toString())}"
        ) {
          user_account {
            id
          }
        }
      }
    """;
    final response = await Toaster.get(addUser);
    var json = response['addUser'];
    if (json != null) {
      return json['user_account']['id'];
    } else {
      throw Exception('Failed to addUser');
    }
  }
}
