import 'package:crust/models/store.dart';
import 'package:crust/utils/enum_util.dart';

class SearchLocationItem {
  final String name;
  final String description;

  SearchLocationItem({
    this.name,
    this.description,
  });

  @override
  String toString() {
    return '{ name: $name, description: $description }';
  }

  factory SearchLocationItem.rehydrate(Map<String, dynamic> json) {
    return SearchLocationItem(
      name: json['name'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'name': this.name,
      'description': this.description,
    };
  }

  factory SearchLocationItem.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return SearchLocationItem(
      name: json['name'],
      description: json['description'],
    );
  }
}

class SearchHistoryItem {
  final SearchHistoryItemType type;
  final String cuisineName;
  final Store store;

  SearchHistoryItem({
    this.type,
    this.cuisineName,
    this.store,
  });

  @override
  String toString() {
    return '{ type: $type, cuisineName: $cuisineName, store: ${store.id} }';
  }

  factory SearchHistoryItem.rehydrate(Map<String, dynamic> json) {
    return SearchHistoryItem(
      type: EnumUtil.fromString(SearchHistoryItemType.values, json['type']),
      cuisineName: json['cuisineName'],
      store: json['store'] != null ? Store.rehydrate(json['store']) : null,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'type': EnumUtil.format(this.type.toString()),
      'cuisineName': this.cuisineName,
      'store': this.store?.toPersist(),
    };
  }
}

enum SearchHistoryItemType { cuisine, store }
