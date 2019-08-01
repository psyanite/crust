import 'package:crust/models/reward.dart';
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
}
