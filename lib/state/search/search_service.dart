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

  static Future<List<SearchLocationItem>> searchLocations(String queryStr) async {
    String query = """
      query {
        locationsBySearch(query: "$queryStr") {
          name,
          description,
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['locationsBySearch'];
    return (json as List).map((s) => SearchLocationItem.fromToaster(s)).toList();
  }

  static Future<List<Store>> searchStores(String queryStr) async {
    String query = """
      query {
        storesBySearch(query: "$queryStr") {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storesBySearch'];
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }

  static Future<Suburb> findSuburbByName(String name) async {
    String query = """
      query {
        suburbByName(name: "$name") {
          ${Suburb.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['suburbByName'];
    return Suburb.fromToaster(json);
  }

  static Future<List<Suburb>> findSuburbsByQuery(String name, String postcode) async {
    var args = [];
    if (name != null) args.add('name: "$name"');
    if (postcode != null) args.add('postcode: $postcode');
    if (args.isEmpty) return List<Suburb>();
    String query = """
      query {
        suburbsByQuery(${args.join(", ")}) {
          ${Suburb.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['suburbsByQuery'];
    return (json as List).map((s) => Suburb.fromToaster(s)).toList();
  }

  static Future<List<Suburb>> findSuburbsBySearch(String queryStr) async {
    String query = """
      query {
        suburbsBySearch(query: "$queryStr", limit: 3) {
          ${Suburb.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['suburbsBySearch'];
    return (json as List).map((s) => Suburb.fromToaster(s)).toList();
  }
}
