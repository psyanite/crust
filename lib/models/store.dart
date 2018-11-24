import 'package:crust/models/Post.dart';

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
      burntCount: this.burntCount
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

class Address {
  final String firstLine;
  final String secondLine;
  final int streetNumber;
  final String streetName;
  final String googleUrl;

  Address({this.firstLine, this.secondLine, this.streetNumber, this.streetName, this.googleUrl});

  factory Address.fromToaster(Map<String, dynamic> address) {
    return Address(
      firstLine: address['address_first_line'],
      secondLine: address['address_second_line'],
      streetNumber: int.tryParse(address['address_street_number']),
      streetName: address['address_street_name'],
      googleUrl: address['google_url'],
    );
  }
}
