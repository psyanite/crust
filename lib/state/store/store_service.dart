import 'package:crust/models/post.dart';
import 'package:crust/models/reward.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class StoreService {
  const StoreService();

  Future<List<Store>> fetchTopStores() async {
    String query = """
      query {
        topStores {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['topStores'];
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }

  Future<Store> fetchStoreById(int storeId) async {
    String query = """
      query {
        storeById(id: $storeId) {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storeById'];
    return Store.fromToaster(json);
  }

  static Future<List<Post>> fetchPostsByStoreId({int storeId, int limit, int offset}) async {
    String query = """
      query {
        postsByStoreId(storeId: $storeId, limit: $limit, offset: $offset) {
          ${Post.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['postsByStoreId'];
    return (json as List).map((p) => Post.fromToaster(p)).toList();
  }

  Future<List<Reward>> fetchRewardsByStoreId(int storeId) async {
    String query = """
      query {
        rewardsByStoreId(storeId: $storeId) {
          ${Reward.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['rewardsByStoreId'];
    return (json as List).map((p) => Reward.fromToaster(p)).toList();
  }

  Future<List<Store>> fetchCurate(String tag) async {
    String query = """
      query {
        curatedByTag(tag: "$tag") {
          stores {
            ${Store.attributes}
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['curatedByTag']['stores'];
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }
}
