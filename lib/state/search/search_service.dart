import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart';
import 'package:crust/services/toaster.dart';
import 'package:geocoder/geocoder.dart' as Geo;

class SearchService {
  const SearchService();

  static const List<String> Cuisines = ['Coffee', 'Asian', 'Tapas', 'Brunch', 'Pizza'];

  static List<SearchHistoryItem> getCuisineSuggestions() {
    return Cuisines.map((c) => SearchHistoryItem(type: SearchHistoryItemType.cuisine, cuisineName: c)).toList();
  }

  static Future<List<SearchLocationItem>> searchLocations(String queryStr, int limit) async {
    String query = """
      query {
        locationsBySearch(query: "$queryStr", limit: $limit) {
          name,
          description,
          coords {
            coordinates
          }
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['locationsBySearch'];
    return (json as List).map((s) => SearchLocationItem.fromToaster(s)).toList();
  }

  static Future<List<Store>> searchStoreByName(String queryStr, int limit, int offset) async {
    String query = """
      query {
        storesByQuery(query: "$queryStr", limit: $limit, offset: $offset) {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storesByQuery'];
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }

  static Future<List<Store>> searchStores(Geo.Address a, String queryStr, int limit, int offset) async {
    var lat = a.coordinates.latitude;
    var lng = a.coordinates.longitude;
    String query = """
      query {
        storesByQueryCoords(query: "$queryStr", lat: $lat, lng: $lng, limit: $limit, offset: $offset) {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storesByQueryCoords'];
    return (json as List).map((s) => Store.fromToaster(s)).toList();
  }

  static Future<List<Store>> searchStoresByCuisineIds(Geo.Address a, Set<int> cuisineIds, int limit, int offset) async {
    var lat = a.coordinates.latitude;
    var lng = a.coordinates.longitude;
    String query = """
      query {
        storesByCuisines(cuisines: [${cuisineIds.join(', ')}], lat: $lat, lng: $lng, limit: $limit, offset: $offset) {
          ${Store.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['storesByCuisines'];
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
        suburbsByQuery(${args.join(', ')}) {
          ${Suburb.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['suburbsByQuery'];
    return (json as List).map((s) => Suburb.fromToaster(s)).toList();
  }

  static Future<List<Suburb>> searchSuburbs(String queryStr) async {
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
