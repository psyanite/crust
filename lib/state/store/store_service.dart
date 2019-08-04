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
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }

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
    return (json as List).map((p) => Post.fromToaster(p)).toList();
  }
}
