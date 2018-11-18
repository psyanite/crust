import 'package:crust/modules/home/models/store.dart';
import 'package:meta/meta.dart';

@immutable
class HomeState {
  final List<Store> stores;

  HomeState({this.stores});

  HomeState copyWith({List<Store> stores}) {
    return new HomeState(
      stores: stores ?? this.stores,
    );
  }

  @override
  String toString() {
    return '''{
                stores: $stores,
            }''';
  }
}
