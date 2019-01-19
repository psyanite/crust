import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class SearchService {
  const SearchService();

  static Future<List<Store>> searchStores(String queryString) async {
    String query = """
      query {
        storesBySearch(query: "$queryString") {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storesBySearch'];
    if (json != null) {
      return (json as List).map((s) => Store.fromToaster(s)).toList();
    } else {
      throw Exception('searchStores');
    }
  }
}
