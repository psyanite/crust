import 'package:crust/models/user.dart';
import 'package:crust/services/toaster.dart';
import 'package:crust/utils/enum_util.dart';

class MeService {
  const MeService();

  static Future<int> getUserIdByUsername(String username) async {
    String query = """
      query {
        userProfileByUsername(username: "$username") {
          user_account {
            id
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userProfileByUsername'];
    return json['user_account']['id'];
  }

  static Future<User> getUser(User user) async {
    String query = """
      query {
        userLogin(
          socialType: "${EnumUtil.format(user.socialType.toString())}", 
          socialId: "${user.socialId}"
        ) {
          user_account {
            id,
            profile {
              profile_picture,
              preferred_name,
              username,
              tagline
            }
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userLogin'];
    return user.copyWith(
      id: json['user_account']['id'],
      profilePicture: json['user_account']['profile']['profile_picture'],
      displayName: json['user_account']['profile']['preferred_name'],
      username: json['user_account']['profile']['username'],
      tagline: json['user_account']['profile']['tagline'],
    );
  }

  Future<int> addUser(User user) async {
    String query = """
      mutation {
        addUser(
          username: "${user.username}",
          displayName: "${user.displayName}",
          email: "${user.email}",
          profilePicture: "${user.profilePicture}",
          socialId: "${user.socialId}",
          socialType: "${EnumUtil.format(user.socialType.toString())}"
        ) {
          user_account {
            id
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addUser'];
    return json['user_account']['id'];
  }

  Future<String> setTagline({userId, tagline}) async {
    String query = """
      mutation {
        setTagline(userId: $userId, tagline: \"\"\"$tagline\"\"\") {
          tagline
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['setTagline'];
    return json['tagline'];
  }

  Future<bool> deleteTagline(int userId) async {
    String query = """
      mutation  {
        deleteTagline(userId: $userId) {
          user_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deleteTagline'];
    return userId == json['user_id'];
  }

  static Future<bool> setProfilePicture({userId, pictureUrl}) async {
    String query = """
      mutation {
        setProfilePicture(userId: $userId, picture: "$pictureUrl") {
          profile_picture
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['setProfilePicture'];
    return pictureUrl == json['profile_picture'];
  }

  static Future<bool> setDisplayName({userId, name}) async {
    String query = """
      mutation {
        setPreferredName(userId: $userId, name: "$name") {
          preferred_name
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['setPreferredName'];
    return name == json['preferred_name'];
  }

  static Future<bool> setUsername({userId, name}) async {
    String query = """
      mutation {
        setUsername(userId: $userId, name: "$name") {
          username
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['setUsername'];
    return name == json['username'];
  }

  Future<bool> setFcmToken({userId, token}) async {
    String query = """
      mutation {
        setFcmToken(userId: $userId, token: "$token") {
          fcm_token
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['setFcmToken'];
    return token == json['fcm_token'];
  }
}
