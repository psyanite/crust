import 'dart:collection';

import 'package:crust/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class StoreState {
  final LinkedHashMap<int, Store> stores;

  StoreState({this.stores});

  StoreState.initialState()
    : stores = LinkedHashMap<int, Store>();

  StoreState copyWith({LinkedHashMap<int, Store> stores}) {
    return StoreState(
      stores: stores ?? this.stores,
    );
  }

  StoreState addStore(Store store) {
    var storesUpdate = this.stores;
    if (store != null) {
      storesUpdate[store.id] = store;
    }
    return StoreState(
      stores: storesUpdate,
    );
  }

  StoreState addStores(List<Store> stores) {
    var storesUpdate = this.stores;
    if (stores != null) {
      storesUpdate.addAll(Map.fromEntries(stores.map((s) => MapEntry<int, Store>(s.id, s))));
    }
    return StoreState(
      stores: storesUpdate,
    );
  }

  @override
  String toString() {
    return '''{
        stores: '${stores.length} stores,
      }''';
  }
}
