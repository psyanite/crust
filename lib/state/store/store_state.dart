import 'dart:collection';

import 'package:crust/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class StoreState {
  final LinkedHashMap<int, Store> stores;

  StoreState({this.stores});

  StoreState copyWith({LinkedHashMap<int, Store> stores}) {
    return StoreState(
      stores: stores ?? this.stores,
    );
  }

  StoreState addStores(List<Store> stores) {
    var storesUpdate = this.stores ?? LinkedHashMap<int, Store>();
    if (stores != null) {
      storesUpdate.addAll(Map.fromEntries(stores.map((s) => MapEntry<int, Store>(s.id, s))));
    }
    return StoreState(
      stores: storesUpdate,
    );
  }

//  @override
//  String toString() {
//    return '''{
//        stores: $stores,
//      }''';
//  }

  @override
  String toString() {
    return '''{
        stores: ${stores != null ? '${stores.length} stores' : null},
      }''';
  }
}
