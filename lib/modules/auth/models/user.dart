import 'package:google_sign_in/google_sign_in.dart';

class User {
  final UserType type;
  final String token;
  final int id;
  final String username;
  final String firstName;
  final String lastName;
  final String fullName;
  final String email;
  final String picture;
  final String socialId;

  User({this.type,
    this.token,
    this.id,
    this.firstName,
    this.lastName,
    this.fullName,
    this.email,
    this.picture,
    this.username,
    this.socialId});

  User copyWith({int id, String username}) {
    return new User(
      type: type,
      token: token,
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName,
      lastName: lastName,
      fullName: fullName,
      email: email,
      picture: picture,
      socialId: socialId
    );
  }

  Map<String, dynamic> toJSON() =>
    <String, dynamic>{
      'token': this.token,
      'id': this.id,
      'username': this.username,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'fullName': this.fullName,
      'email': this.email,
      'picture': this.picture,
      'socialId': this.socialId
    };

  factory User.fromJSON(Map<String, dynamic> json) =>
    new User(
      type: json['type'],
      token: json['token'],
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      fullName: json['fullName'],
      email: json['email'],
      picture: json['picture'],
      socialId: json['socialId']);

  factory User.fromFacebook(String token, Map<String, dynamic> json) {
    return User(
      type: UserType.facebook,
      token: token,
      firstName: json['first_name'],
      lastName: json['last_name'],
      fullName: json['name'],
      email: json['email'],
      picture: json['picture']['data']['url'],
      socialId: json['id']);
  }

  factory User.fromGoogle(GoogleSignInAccount googleUser) {
    return User(
      type: UserType.google,
      fullName: googleUser.displayName,
      email: googleUser.email,
      picture: googleUser.photoUrl,
      socialId: googleUser.id);
  }

  @override
  String toString() {
    return '{ id: $id, type: $type, social_id: $socialId, fullName: $fullName, email: $email }';
  }
}

enum UserType { facebook, google }
