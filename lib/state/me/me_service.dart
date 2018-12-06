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
    if (json != null) {
      return json['user_account']['id'];
    } else {
      throw Exception('Failed to getUserIdByUsername');
    }
  }

  static Future<User> getUser(User user) async {
    String query = """
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
    final response = await Toaster.get(query);
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
    if (json != null) {
      return json['user_account']['id'];
    } else {
      throw Exception('Failed to addUser');
    }
  }

  Future<Set<int>> favoriteReward({ userId, rewardId }) async {
    String query = """
      mutation {
        favoriteReward(userId: $userId, rewardId: $rewardId) {
          favorite_rewards {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoriteReward'];
    if (json != null) {
      return Set<int>.from(json['favorite_rewards'].map((r) => r['id']));
    } else {
      throw Exception('Failed to favoriteReward(userId: $userId, rewardId: $rewardId)');
    }
  }

  Future<Set<int>> unfavoriteReward({ userId, rewardId }) async {
    String query = """
      mutation {
        unfavoriteReward(userId: $userId, rewardId: $rewardId) {
          favorite_rewards {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['unfavoriteReward'];
    if (json != null) {
      return Set<int>.from(json['favorite_rewards'].map((r) => r['id']));
    } else {
      throw Exception('Failed to unfavoriteReward(userId: $userId, rewardId: $rewardId)');
    }
  }

  Future<Map<String, Set<int>>> fetchFavorites(userId) async {
    String query = """
      query {
        userAccountById(id: $userId) {
          favorite_rewards {
            id,
          },
          favorite_stores {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    if (json != null) {
      var rewards = Set<int>.from(json['favorite_rewards'].map((r) => r['id']));
      var stores = Set<int>.from(json['favorite_stores'].map((r) => r['id']));
      return { 'rewards': rewards, 'stores': stores };
    } else {
      throw Exception('Failed to fetchFavorites(userId: $userId)');
    }
  }
}
