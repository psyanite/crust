import 'package:crust/models/store.dart';

class StoreGroup {
  final int id;
  final String name;
  final List<Store> stores;

  StoreGroup({
    this.id,
    this.name,
    this.stores,
  });

  factory StoreGroup.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return StoreGroup(
      id: json['id'],
      name: json['name'],
      stores: json['stores'] != null ? List<Store>.from(json['stores'].map(
        (s) => Store.fromToaster(s),
      )) : null,
    );
  }
}
