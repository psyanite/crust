import 'package:crust/models/store.dart' as MyStore;

class Curate {
  final String tag;
  final String title;
  final List<MyStore.Store> stores;

  Curate({
    this.tag,
    this.title,
    this.stores,
  });

  Curate copyWith({List<MyStore.Store> stores}) {
    return Curate(
      tag: this.tag,
      title: this.title,
      stores: stores ?? this.stores,
    );
  }
}
