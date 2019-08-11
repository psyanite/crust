import 'package:crust/services/toaster.dart';

class FollowService {
  const FollowService();

  Future<List<int>> fetchFollowedUsers(userId) async {
    String query = """
      query {
        followedUsers(userId: $userId)
      }
    """;
    final response = await Toaster.get(query);
    var json = response['followedUsers'];
    return List<int>.from(json);
  }

  Future<List<int>> fetchFollowedStores(userId) async {
    String query = """
      query {
        followedStores(userId: $userId)
      }
    """;
    final response = await Toaster.get(query);
    var json = response['followedStores'];
    return List<int>.from(json);
  }

  Future<int> followUser({ userId, followerId }) async {
    String query = """
      mutation {
        addUserFollower(userId: $userId, followerId: $followerId) {
          user_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addUserFollower'];
    return json['userId'];
  }

  Future<int> unfollowUser({ userId, followerId }) async {
    String query = """
      mutation {
        deleteUserFollower(userId: $userId, followerId: $followerId) {
          user_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deleteUserFollower'];
    return json['user_id'];
  }

  Future<int> followStore({ storeId, followerId }) async {
    String query = """
      mutation {
        addStoreFollower(storeId: $storeId, followerId: $followerId) {
          store_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addStoreFollower'];
    return json['store_id'];
  }

  Future<int> unfollowStore({ storeId, followerId }) async {
    String query = """
      mutation {
        deleteStoreFollower(storeId: $storeId, followerId: $followerId) {
          store_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deleteStoreFollower'];
    return json['store_id'];
  }
}
