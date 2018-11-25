import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class UserService {
  const UserService();

  Future<List<Store>> fetchUserByUserId() async {
    String query = """
      query {
        allStores {
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
      }
    """;
    final response = await Toaster.get(query);
    if (response['allStores'] != null) {
      return (response['allStores'] as List)
          .map((s) => Store(
                id: s['id'],
                name: s['name'],
                phoneNumber: s['phone_number'],
                coverImage: s['cover_image'],
                address: Address.fromToaster(s['address']),
                location: s['location'] == null ? null : s['location']['name'],
                suburb: s['suburb'] == null ? null : s['suburb']['name'],
                heartCount: s['ratings']['heart_ratings'],
                okayCount: s['ratings']['okay_ratings'],
                burntCount: s['ratings']['burnt_ratings'],
                cuisines: List<String>.from(s['cuisines'].map(
                  (c) => c['name'],
                )),
              ))
          .toList();
    } else {
      throw Exception('Failed to allStores');
    }
  }
}
