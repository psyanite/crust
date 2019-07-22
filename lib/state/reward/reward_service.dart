import 'package:crust/models/reward.dart';
import 'package:crust/services/toaster.dart';

class RewardService {
  const RewardService();

  Future<List<Reward>> fetchRewards() async {
    String query = """
      query {
        allRewards {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['allRewards'];
    return (json as List).map((r) => Reward.fromToaster(r)).toList();
  }
}
