import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';
import 'package:crust/models/user_reward.dart';
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

  Future<Set<int>> favoriteStore({ userId, storeId }) async {
    String query = """
      mutation {
        favoriteStore(userId: $userId, storeId: $storeId) {
          favorite_stores {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoriteStore'];
    if (json != null) {
      return Set<int>.from(json['favorite_stores'].map((s) => s['id']));
    } else {
      throw Exception('Failed to favoriteStore(userId: $userId, storeId: $storeId)');
    }
  }

  Future<Set<int>> unfavoriteStore({ userId, storeId }) async {
    String query = """
      mutation {
        unfavoriteStore(userId: $userId, storeId: $storeId) {
          favorite_stores {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['unfavoriteStore'];
    if (json != null) {
      return Set<int>.from(json['favorite_stores'].map((s) => s['id']));
    } else {
      throw Exception('Failed to unfavoriteStore(userId: $userId, storeId: $storeId)');
    }
  }

  Future<Map<String, dynamic>> fetchFavorites(userId) async {
    String query = """
      query {
        userAccountById(id: $userId) {
          favorite_rewards {
            ${Reward.attributes}
          },
          favorite_stores {
            ${Store.attributes}
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    if (json != null) {
      var rewards = (json['favorite_rewards'] as List).map((r) => Reward.fromToaster(r)).toList();
      var stores = (json['favorite_stores'] as List).map((s) => Store.fromToaster(s)).toList();
      return { 'rewards': rewards, 'stores': stores };
    } else {
      throw Exception('Failed to fetchFavorites(userId: $userId)');
    }
  }

  Future<UserReward> fetchUserReward({ userId, rewardId }) async {
    String query = """
      query {
        userRewardBy(userId: $userId, rewardId: $rewardId) {
          reward {
            id
          },
          unique_code,
          is_redeemed
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userRewardBy'];
    if (json != null) {
      var result = (json as List).map((u) => UserReward.fromToaster(u)).toList();
      return result.length > 0 ? result.first : null;
    } else {
      throw Exception('Failed to fetchUserReward(userId: $userId, rewardId: $rewardId)');
    }
  }

  Future<UserReward> addUserReward({ userId, rewardId }) async {
    String query = """
      mutation {
        addUserReward(userId: $userId, rewardId: $rewardId) {
          reward {
            id
          },
          unique_code,
          is_redeemed
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addUserReward'];
    if (json != null) {
      var result = (json as List).map((u) => UserReward.fromToaster(u)).toList();
      return result.length > 0 ? result.first : null;
    } else {
      throw Exception('Failed to addUserReward(userId: $userId, rewardId: $rewardId)');
    }
  }
}
