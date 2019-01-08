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
            phone_number,
            cover_image,
            address {
              address_first_line,
              address_second_line,
              address_street_number,
              address_street_name,
              google_url,
            },
            location {
              id,
              name,
            },
            suburb {
              id,
              name,
            },
            cuisines {
              id,
              name,
            },
            ratings {
              heart_ratings,
              okay_ratings,
              burnt_ratings
            }
          },
          store_group {
            id,
            name,
            stores {
              id,
              name,
              phone_number,
              cover_image,
              address {
                address_first_line,
                address_second_line,
                address_street_number,
                address_street_name,
                google_url,
              },
              location {
                id,
                name,
              },
              suburb {
                id,
                name,
              },
              cuisines {
                id,
                name,
              },
              ratings {
                heart_ratings,
                okay_ratings,
                burnt_ratings
              }
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
