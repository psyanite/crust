import 'package:crust/modules/home/models/store.dart';
import 'package:crust/services/toaster.dart';

class HomeRepository {
  const HomeRepository();

  Future<List<Store>> fetchStores() async {
    String getAllStores = """
    query {
      allStores {
        id,
        name,
        cover_image,
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
        }
      }
    }
  """;
    final response = await Toaster.get(getAllStores);

    if (response['allStores'] != null) {
      return (response['allStores'] as List)
          .map((s) => Store.fromJson(s))
          .toList();
    } else {
      throw Exception('Failed');
    }
  }
}
