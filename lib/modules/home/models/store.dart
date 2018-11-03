class Store {
  final int id;
  final String name;

  Store({this.id, this.name});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
    );
  }
}