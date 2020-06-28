import 'package:crust/models/store.dart';
import 'package:crust/utils/enum_util.dart';
import 'package:geocoder/geocoder.dart' as Geo;

class SearchLocationItem {
  final String name;
  final String description;
  final double lat;
  final double lng;

  SearchLocationItem({
    this.name,
    this.description,
    this.lat,
    this.lng,
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

  Geo.Address toGeoAddress() {
    return Geo.Address(
      coordinates: Geo.Coordinates(lat, lng,),
      addressLine: name,
      locality: description,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'name': this.name,
      'description': this.description,
      'lat': this.lat,
      'lng': this.lng,
    };
  }

  factory SearchLocationItem.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    var coords = json['coords'];
    return SearchLocationItem(
      name: json['name'],
      description: json['description'],
      lng: coords != null ? coords['coordinates'][0] : null,
      lat: coords != null ? coords['coordinates'][1] : null,
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
