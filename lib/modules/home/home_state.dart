import 'package:crust/modules/home/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final List<Store> stores;
  final String error;

  HomeState({
    this.stores,
    this.error
  });

  HomeState copyWith({List<Store> stores, String error}) {
    return new HomeState(
      stores: stores ?? this.stores,
      error: error ?? this.error,
    );
  }

  @override
  String toString() {
    return '''{
                stores: $stores,
                error: $error,
            }''';
  }
}
