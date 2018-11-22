class Store {
  final int id;
  final String name;
  final String coverImage;
  final String location;
  final String suburb;
  final List<String> cuisines;

  Store({this.id, this.name, this.coverImage, this.location, this.suburb, this.cuisines});

  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      id: json['id'],
      name: json['name'],
      coverImage: json['cover_image'],
      location: json['location'] == null ? null : json['location']['name'],
      suburb: json['suburb'] == null ? null : json['suburb']['name'],
      cuisines: List<String>.from(json['cuisines'].map((c) => c['name']))
    );
  }
}

class Cuisine {
  final int id;
  final String name;

  Cuisine({this.id, this.name});

  factory Cuisine.fromJson(Map<String, dynamic> json) {
    return Cuisine(id: json['id'], name: json['name']);
  }
}

class Location {
  final int id;
  final String name;

  Location({this.id, this.name});

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(id: json['id'], name: json['name']);
  }
}

class Suburb {
  final int id;
  final String name;

  Suburb({this.id, this.name});

  factory Suburb.fromJson(Map<String, dynamic> json) {
    return Suburb(id: json['id'], name: json['name']);
  }
}
