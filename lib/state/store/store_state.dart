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
    var clone = cloneStores();
    clone[store.id] = store;
    return copyWith(stores: clone);
  }

  StoreState addStores(List<Store> stores) {
    return copyWith(stores: cloneStores()..addEntries(stores.map((s) => MapEntry<int, Store>(s.id, s))));
  }

  StoreState setTopStores(List<Store> stores) {
    stores.shuffle();
    return copyWith(topStores: LinkedHashMap<int, Store>.fromEntries(stores.map((s) => MapEntry<int, Store>(s.id, s))));
  }

  StoreState addTopStores(List<Store> stores) {
    stores.shuffle();
    return copyWith(topStores: cloneTopStores()..addEntries(stores.map((s) => MapEntry<int, Store>(s.id, s))));
  }

  LinkedHashMap<int, Store> cloneStores() {
    return LinkedHashMap<int, Store>.from(this.stores);
  }

  LinkedHashMap<int, Store> cloneTopStores() {
    return LinkedHashMap<int, Store>.from(this.topStores);
  }

  @override
  String toString() {
    return '''{ stores: ${stores.length}, topStores: ${topStores.length} }''';
  }
}
