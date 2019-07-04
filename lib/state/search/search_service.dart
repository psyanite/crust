import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';

class SearchService {
  const SearchService();

  static const List<String> Cuisines = ["Café", "Modern Australian", "Italian", "Brunch", "French", "Pizza"];

  static List<String> getCuisines() {
    return Cuisines;
  }

  static List<SearchHistoryItem> getCuisineSuggestions() {
    return Cuisines.map((c) => SearchHistoryItem(type: SearchHistoryItemType.cuisine, cuisineName: c)).toList();
  }

  static Future<List<SearchLocationItem>> searchLocations(String queryString) async {
    String query = """
      query {
        locationsBySearch(query: "$queryString") {
          name,
          description,
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['locationsBySearch'];
    if (json != null) {
      return (json as List).map((s) => SearchLocationItem.fromToaster(s)).toList();
    } else {
      throw Exception('searchLocations');
    }
  }

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
