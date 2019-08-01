import 'package:crust/models/post.dart';
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
    return json['user_account']['id'];
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
              preferred_name,
              username
            }
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userLoginBy'];
    return user.copyWith(
        id: json['user_account']['id'],
        profilePicture: json['user_account']['profile']['profile_picture'],
        displayName: json['user_account']['profile']['preferred_name'],
        username: json['user_account']['profile']['username']);
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
    return Set<int>.from(json['favorite_rewards'].map((r) => r['id']));
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
    return Set<int>.from(json['favorite_rewards'].map((r) => r['id']));
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
    return Set<int>.from(json['favorite_stores'].map((s) => s['id']));
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
    return Set<int>.from(json['favorite_stores'].map((s) => s['id']));
  }

  Future<Set<int>> favoritePost({ userId, postId }) async {
    String query = """
      mutation {
        favoritePost(userId: $userId, postId: $postId) {
          favorite_posts {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoritePost'];
    return Set<int>.from(json['favorite_posts'].map((p) => p['id']));
  }

  Future<Set<int>> unfavoritePost({ userId, postId }) async {
    String query = """
      mutation {
        unfavoritePost(userId: $userId, postId: $postId) {
          favorite_posts {
            id,
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['unfavoritePost'];
    return Set<int>.from(json['favorite_posts'].map((p) => p['id']));
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
          favorite_posts {
            ${Post.attributes}
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    var rewards = (json['favorite_rewards'] as List).map((r) => Reward.fromToaster(r)).toList();
    var stores = (json['favorite_stores'] as List).map((s) => Store.fromToaster(s)).toList();
    var posts = (json['favorite_posts'] as List).map((s) => Post.fromToaster(s)).toList();
    return { 'rewards': rewards, 'stores': stores, 'posts': posts };
  }

  static Future<List<UserReward>> fetchUserRewards(userId) async {
    String query = """
      query {
        allUserRewardsByUserId(userId: $userId) {
          reward {
            ${Reward.attributes}
          },
          unique_code,
          redeemed_at
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['allUserRewardsByUserId'];
    return (json as List).map((u) => UserReward.fromToaster(u)).toList();
  }

  Future<UserReward> fetchUserReward({ userId, rewardId }) async {
    String query = """
      query {
        userRewardBy(userId: $userId, rewardId: $rewardId) {
          reward {
            id
          },
          unique_code,
          redeemed_at
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userRewardBy'];
    return UserReward.fromToaster(json);
  }

  Future<UserReward> addUserReward({ userId, rewardId }) async {
    String query = """
      mutation {
        addUserReward(userId: $userId, rewardId: $rewardId) {
          reward {
            id
          },
          unique_code,
          redeemed_at
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addUserReward'];
    return UserReward.fromToaster(json);
  }
}
