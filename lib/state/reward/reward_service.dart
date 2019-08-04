import 'package:crust/models/reward.dart';
import 'package:crust/models/user_reward.dart';
import 'package:crust/services/toaster.dart';

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
    if (response == null) return null;
    var json = response['rewardByCode'];
    return Reward.fromToaster(json);
  }

  static Future<UserReward> fetchUserReward({ userId, rewardId }) async {
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
    if (response == null) return null;
    var json = response['userRewardBy'];
    return UserReward.fromToaster(json);
  }

  static Future<UserReward> addUserReward({ userId, rewardId }) async {
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
    if (response == null) return null;
    var json = response['addUserReward'];
    return UserReward.fromToaster(json);
  }

  Future<List<Reward>> fetchRewards() async {
    String query = """
      query {
        allRewards {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    if (response == null) return null;
    var json = response['allRewards'];
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
    if (response == null) return null;
    var json = response['topRewards'];
    return (json as List).map((r) => Reward.fromToaster(r)).toList();
  }
}
