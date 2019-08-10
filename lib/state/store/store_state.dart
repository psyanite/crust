import 'dart:collection';

import 'package:crust/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class StoreState {
  final LinkedHashMap<int, Store> stores;
  final LinkedHashMap<int, Store> topStores;

  StoreState({this.stores, this.topStores});

  StoreState.initialState()
    : stores = LinkedHashMap<int, Store>(),
      topStores = LinkedHashMap<int, Store>();

  StoreState copyWith({LinkedHashMap<int, Store> stores, LinkedHashMap<int, Store> topStores}) {
    return StoreState(
      stores: stores ?? this.stores,
      topStores: topStores ?? this.topStores,
    );
  }

  StoreState addStore(Store store) {
    var clone = LinkedHashMap<int, Store>.from(this.stores);
    clone[store.id] = store;
    return copyWith(stores: clone);
  }

  StoreState addStores(List<Store> stores) {
    var clone = LinkedHashMap<int, Store>.from(this.stores);
    clone.addEntries(stores.map((s) => MapEntry<int, Store>(s.id, s)));
    return copyWith(stores: clone);
  }

  StoreState addTopStores(List<Store> stores) {
    stores.shuffle();
    var clone = LinkedHashMap<int, Store>.from(this.topStores);
    clone.addEntries(stores.map((s) => MapEntry<int, Store>(s.id, s)));
    return copyWith(topStores: clone);
  }

  @override
  String toString() {
    return '''{
        stores: ${stores.length} stores,
        topStores: ${topStores.length} stores,
      }''';
  }
}
