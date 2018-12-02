import 'package:crust/models/reward.dart';
import 'package:crust/services/toaster.dart';

class RewardService {
  const RewardService();

  Future<List<Reward>> fetchRewards() async {
    String query = """
      query {
        allRewards {
          id,
          name,
          description,
          type,
          store {
            id,
            name,
            location {
              name
            },
            suburb {
              name
            },
          },
          store_group {
            id,
            name,
            stores {
              id,
              name,
              location {
                name
              },
              suburb {
                name
              },
            }
          },
          valid_from,
          valid_until,
          promo_image,
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['allRewards'];
    if (json != null) {
      return (json as List).map((r) => Reward.fromToaster(r)).toList();
    } else {
      throw Exception('Failed to fetchRewards');
    }
  }
}
