class Store {
  final int userId;
  final int id;
  final String title;
  final String body;

  Store({this.userId, this.id, this.title, this.body});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}
