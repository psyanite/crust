import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class FavoriteService {
  const FavoriteService();

  Future<Set<int>> favoriteReward({userId, rewardId}) async {
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

  Future<Set<int>> unfavoriteReward({userId, rewardId}) async {
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

  Future<Set<int>> favoriteStore({userId, storeId}) async {
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

  Future<Set<int>> unfavoriteStore({userId, storeId}) async {
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

  Future<Set<int>> favoritePost({userId, postId}) async {
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

  Future<Set<int>> unfavoritePost({userId, postId}) async {
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

  Future<List<Reward>> fetchFavoriteRewards(userId) async {
    String query = """
      query {
        favoriteRewards(userId: $userId) {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoriteRewards'];
    return (json as List).map((r) => Reward.fromToaster(r)).toList();
  }

  Future<Map<String, dynamic>> fetchFavorites(userId) async {
    String query = """
      query {
        userAccountById(id: $userId) {
          favorite_stores {
            ${Store.attributes}
          },
          favorite_posts {
            id
          },
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userAccountById'];
    var stores = (json['favorite_stores'] as List).map((s) => Store.fromToaster(s)).toList();
    var posts = (json['favorite_posts'] as List).map((p) => p['id'] as int).toList();
    return {'stores': stores, 'postIds': posts};
  }
}
