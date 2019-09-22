import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/services/toaster.dart';
import 'package:geocoder/geocoder.dart' as Geo;

class RewardService {
  const RewardService();

  static Future<Reward> fetchRewardByCode(String code) async {
    String query = """
      query {
        rewardByCode(code: "$code") {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['rewardByCode'];
    return Reward.fromToaster(json);
  }

  static Future<UserReward> fetchUserReward({ userId, rewardId }) async {
    String query = """
      query {
        userRewardBy(userId: $userId, rewardId: $rewardId) {
          ${UserReward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['userRewardBy'];
    return UserReward.fromToaster(json);
  }

  static Future<UserReward> addUserReward({ userId, rewardId }) async {
    String query = """
      mutation {
        addUserReward(userId: $userId, rewardId: $rewardId) {
          ${UserReward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addUserReward'];
    return UserReward.fromToaster(json);
  }

  static Future<Reward> rewardsByStoreId(int storeId) async {
    String query = """
      query {
        rewardsByStoreId(storeId: $storeId) {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['rewardsByStoreId'];
    return Reward.fromToaster(json);
  }

  static Future<List<Reward>> fetchRewards({int limit, int offset, Geo.Address address}) async {
    var lat = address.coordinates.latitude;
    var lng = address.coordinates.longitude;
    String query = """
      query {
        rewardsByCoords(lat: $lat, lng: $lng, limit: $limit, offset: $offset) {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['rewardsByCoords'];
    return (json as List).map((r) => Reward.fromToaster(r)).toList();
  }

  Future<List<Reward>> fetchTopRewards() async {
    String query = """
      query {
        topRewards {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['topRewards'];
    return (json as List).map((r) => Reward.fromToaster(r)).toList();
  }

  Future<List<UserReward>> fetchRedeemedRewards(userId) async {
    String query = """
      query {
        redeemedRewards(userId: $userId) {
          reward {
            ${Reward.attributes}
          },
          ${UserReward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['redeemedRewards'];
    return (json as List).map((u) => UserReward.fromToaster(u)).toList();
  }
}
