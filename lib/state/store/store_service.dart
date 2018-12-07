import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class StoreService {
  const StoreService();

  Future<List<Store>> fetchStores() async {
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
    var json = response['allStores'];
    if (json != null) {
      return (json as List).map((s) => Store.fromToaster(s)).toList();
    } else {
      throw Exception('Failed to fetchStores');
    }
  }

  Future<List<Post>> fetchPostsByStoreId(int storeId) async {
    String query = """
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
            body,
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['postsByStoreId'];
    if (json != null) {
      return (json as List).map((p) => Post.fromToaster(p)).toList();
    } else {
      throw Exception('Failed to fetchPostsByStoreId');
    }
  }
}
