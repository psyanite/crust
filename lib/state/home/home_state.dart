import 'dart:collection';

import 'package:crust/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final LinkedHashMap<int, Store> stores;

  HomeState({this.stores});

  HomeState copyWith({LinkedHashMap<int, Store> stores}) {
    return new HomeState(
      stores: stores ?? this.stores,
    );
  }
}
