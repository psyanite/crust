import 'package:crust/models/post.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class StoreService {
  const StoreService();

  Future<List<Store>> fetchStores() async {
    String query = """
      query {
        allStores {
          ${Store.attributes}
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
    if (json != null) {
      return Store.fromToaster(json);
    } else {
      throw Exception('Failed to storeById');
    }
  }

  Future<List<Post>> fetchPostsByStoreId(int storeId) async {
    String query = """
      query {
        postsByStoreId(storeId: $storeId) {
          ${Post.attributes}
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
