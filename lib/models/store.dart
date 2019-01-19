import 'package:crust/models/post.dart';

class Store {
  final int id;
  final String name;
  final String phoneNumber;
  final String coverImage;
  final Address address;
  final String location;
  final String suburb;
  final List<String> cuisines;
  final List<Post> posts;
  final int heartCount;
  final int okayCount;
  final int burntCount;

  Store({
    this.id,
    this.name,
    this.phoneNumber,
    this.coverImage,
    this.address,
    this.location,
    this.suburb,
    this.cuisines,
    this.posts,
    this.heartCount,
    this.okayCount,
    this.burntCount,
  });

  Store copyWith({List<Post> posts}) {
    return Store(
        id: this.id,
        name: this.name,
        phoneNumber: this.phoneNumber,
        coverImage: this.coverImage,
        address: this.address,
        suburb: this.suburb,
        cuisines: this.cuisines,
        posts: posts ?? this.posts,
        heartCount: this.heartCount,
        okayCount: this.okayCount,
        burntCount: this.burntCount);
  }

  factory Store.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Store(
      id: json['id'],
      name: json['name'],
      phoneNumber: json['phone_number'],
      coverImage: json['cover_image'],
      address: json['address'] != null ? Address.fromToaster(json['address']) : null,
      location: json['location'] != null ? json['location']['name'] : null,
      suburb: json['suburb'] != null ? json['suburb']['name'] : null,
      heartCount: json['ratings'] != null ? json['ratings']['heart_ratings'] : null,
      okayCount: json['ratings'] != null ? json['ratings']['okay_ratings'] : null,
      burntCount: json['ratings'] != null ? json['ratings']['burnt_ratings'] : null,
      cuisines: json['cuisines'] != null
          ? List<String>.from(json['cuisines'].map(
              (c) => c['name'],
            ))
          : null,
    );
  }

  static const attributes = """
    id,
    name,
    phone_number,
    cover_image,
    address {
      address_first_line,
      address_second_line,
      address_street_number,
      address_street_name,
      google_url,
    },
    location {
      id,
      name,
    },
    suburb {
      id,
      name,
    },
    cuisines {
      id,
      name,
    },
    ratings {
      heart_ratings,
      okay_ratings,
      burnt_ratings
    }
  """;

  @override
  String toString() {
    return '{ id: $id, name: $name }';
  }
}

class Cuisine {
  final int id;
  final String name;

  Cuisine({this.id, this.name});

  factory Cuisine.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Cuisine(id: json['id'], name: json['name']);
  }
}

class Location {
  final int id;
  final String name;

  Location({this.id, this.name});

  factory Location.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Location(id: json['id'], name: json['name']);
  }
}

class Suburb {
  final int id;
  final String name;

  Suburb({this.id, this.name});

  factory Suburb.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Suburb(id: json['id'], name: json['name']);
  }
}

class Address {
  final String firstLine;
  final String secondLine;
  final int streetNumber;
  final String streetName;
  final String googleUrl;

  Address({this.firstLine, this.secondLine, this.streetNumber, this.streetName, this.googleUrl});

  factory Address.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return Address(
      firstLine: json['address_first_line'],
      secondLine: json['address_second_line'],
      streetNumber: int.tryParse(json['address_street_number']),
      streetName: json['address_street_name'],
      googleUrl: json['google_url'],
    );
  }
}
