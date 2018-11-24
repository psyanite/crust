import 'package:crust/models/Post.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class HomeService {
  const HomeService();

  Future<List<Store>> fetchStores() async {
    String getAllStores = """
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
    final response = await Toaster.get(getAllStores);
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

  Future<List<Post>> fetchPostsByStoreId(int storeId) async {
    String getAllStores = """
      query {
        postsByStoreId(storeId: $storeId) {
          id,
          type,
          store {
            id,
            name,
            cover_image,
          },
          posted_by {
            id,
            profile {
              username,
              display_name,
              profile_picture,
            }
          },
          posted_at,
          post_photos {
            id,
            photo,
          },
          post_review {
            id,
            overall_score,
            taste_score,
            service_score,
            value_score,
            ambience_score,
            body,
          }
        }
      }
    """;
    final response = await Toaster.get(getAllStores);
    if (response['postsByStoreId'] != null) {
      return (response['postsByStoreId'] as List).map((p) => Post.fromToaster(p)).toList();
    } else {
      throw Exception('Failed to postsByStoreId');
    }
  }
}
