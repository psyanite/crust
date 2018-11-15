import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/services/toaster.dart';

class AuthRepository {
  const AuthRepository();

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

  static Future<int> getUserAccountId(User user) async {
    String getUserLogin = """
      query {
        userLoginBy(
          social_type: "${user.type.toString().split('.')[1]}", 
          social_id: "${user.socialId}"
          ) {
          user_account {
            id
          }
        }
      }
    """;
    final response = await Toaster.get(getUserLogin);
    if (response['userLoginBy'] != null) {
      return response['userLoginBy']['user_account']['id'];
    } else {
      return null;
    }
  }

  Future<int> addUser(User user) async {
    String addUser = """
    mutation {
      addUser(
        username: "${user.username}",
        display_name: "${user.fullName}",
        email: "${user.email}",
        profile_picture: "${user.picture}",
        social_id: "${user.socialId}",
        social_type: "${user.type.toString().split('.')[1]}"
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

  static Future<int> addMeow(User user) async {
    String addUser = """
    mutation {
      addUser(
        username: "${user.username}",
        display_name: "${user.fullName}",
        email: "${user.email}",
        profile_picture: "${user.picture}",
        social_id: "${user.socialId}",
        social_type: "${user.type.toString().split('.')[1]}"
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
