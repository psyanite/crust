import 'dart:collection';

import 'package:crust/models/curate.dart';
import 'package:crust/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class StoreState {
  final LinkedHashMap<int, Store> stores;
  final LinkedHashMap<int, Store> topStores;
  final LinkedHashMap<int, List<int>> rewards;
  final LinkedHashMap<String, Curate> curates;

  StoreState({this.stores, this.topStores, this.rewards, this.curates});

  StoreState.initialState()
      : stores = LinkedHashMap<int, Store>(),
        topStores = LinkedHashMap<int, Store>(),
        rewards = LinkedHashMap<int, List<int>>(),
        curates = LinkedHashMap<String, Curate>();

  StoreState copyWith({LinkedHashMap<int, Store> stores, LinkedHashMap<int, Store> topStores, LinkedHashMap<int, List<int>> rewards, LinkedHashMap<String, Curate> curates}) {
    return StoreState(
      stores: stores ?? this.stores,
      topStores: topStores ?? this.topStores,
      rewards: rewards ?? this.rewards,
      curates: curates ?? this.curates,
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

  StoreState addStoreRewards(int storeId, List<int> rewards) {
    rewards.shuffle();
    return copyWith(rewards: cloneStoreRewards()..addEntries([MapEntry<int, List<int>>(storeId, rewards)]));
  }

  StoreState addCurate(Curate curate) {
    return copyWith(curates: cloneCurates()..addEntries([MapEntry<String, Curate>(curate.tag, curate)]));
  }

  LinkedHashMap<int, Store> cloneStores() {
    return LinkedHashMap<int, Store>.from(this.stores);
  }

  LinkedHashMap<int, Store> cloneTopStores() {
    return LinkedHashMap<int, Store>.from(this.topStores);
  }

  LinkedHashMap<int, List<int>> cloneStoreRewards() {
    return LinkedHashMap<int, List<int>>.from(this.rewards);
  }

  LinkedHashMap<String, Curate> cloneCurates() {
    return LinkedHashMap<String, Curate>.from(this.curates);
  }

  @override
  String toString() {
    return '''{ stores: ${stores.length}, topStores: ${topStores.length} }''';
  }
}
