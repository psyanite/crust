import 'package:crust/models/post.dart';
import 'package:crust/utils/enum_util.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final int id;
  final int storeId;
  final String username;
  final String firstName;
  final String lastName;
  final String displayName;
  final String email;
  final String profilePicture;
  final String tagline;
  final SocialType socialType;
  final String socialId;
  final String token;
  final String fcmToken;
  final List<Post> posts;

  User({
    this.id,
    this.storeId,
    this.username,
    this.firstName,
    this.lastName,
    this.displayName,
    this.email,
    this.profilePicture,
    this.tagline,
    this.socialType,
    this.socialId,
    this.token,
    this.fcmToken,
    this.posts,
  });

  User copyWith({int id, String username, String profilePicture, String displayName, List<Post> posts, String tagline, String fcmToken, String storeId}) {
    return User(
      id: id ?? this.id,
      username: username ?? this.username,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName ?? this.displayName,
      email: email,
      profilePicture: profilePicture ?? this.profilePicture,
      tagline: tagline ?? this.tagline,
      socialType: socialType,
      socialId: socialId,
      token: token,
      fcmToken: fcmToken ?? this.fcmToken,
      posts: posts ?? this.posts,
    );
  }

  User setTagline(String tagline) {
    return User(
      id: id,
      storeId: storeId,
      username: username,
      firstName: firstName,
      lastName: lastName,
      displayName: displayName,
      email: email,
      profilePicture: profilePicture,
      tagline: tagline,
      socialType: socialType,
      socialId: socialId,
      token: token,
      fcmToken: fcmToken,
      posts: posts,
    );
  }

  Map<String, dynamic> toPersist() {
    return <String, dynamic>{
      'id': this.id,
      'username': this.username,
      'firstName': this.firstName,
      'lastName': this.lastName,
      'displayName': this.displayName,
      'email': this.email,
      'profilePicture': this.profilePicture,
      'tagline': this.tagline,
      'socialType': EnumUtil.format(this.socialType.toString()),
      'socialId': this.socialId,
      'token': this.token,
      'fcmToken': this.fcmToken,
    };
  }

  factory User.rehydrate(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      displayName: json['displayName'],
      email: json['email'],
      profilePicture: json['profilePicture'],
      tagline: json['tagline'],
      socialType: EnumUtil.fromString(SocialType.values, json['socialType']),
      socialId: json['socialId'],
      token: json['token'],
      fcmToken: json['fcmToken'],
    );
  }

  factory User.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    var admin = json['admin'];
    return User(
      id: json['id'],
      storeId: admin != null ? admin['store_id'] : null,
      email: json['email'],
      username: json['profile']['username'],
      displayName: json['profile']['preferred_name'],
      profilePicture: json['profile']['profile_picture'],
      tagline: json['profile']['tagline'],
      fcmToken: json['fcmToken'],
      posts: json['posts'] != null ? (json['posts'] as List).map((p) => Post.fromToaster(p)).toList() : null,
    );
  }

  factory User.fromProfileToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    var admin = json['admin'];
    return User(
      id: json['user_id'],
      storeId: admin != null ? admin['store_id'] : null,
      username: json['username'],
      displayName: json['preferred_name'],
      profilePicture: json['profile_picture'],
      tagline: json['tagline'],
      fcmToken: json['fcmToken'],
    );
  }

  factory User.fromFacebook(String token, Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      displayName: json['name'],
      email: json['email'],
      profilePicture: json['picture']['data']['url'],
      socialType: SocialType.facebook,
      socialId: json['id'],
      token: token,
    );
  }

  factory User.fromGoogle(GoogleSignInAccount googleUser) {
    return User(
      displayName: googleUser.displayName,
      email: googleUser.email,
      profilePicture: googleUser.photoUrl,
      socialType: SocialType.google,
      socialId: googleUser.id,
    );
  }

  bool isAdmin() {
    return storeId != null;
  }

  @override
  String toString() {
    return '{ id: $id, socialType: $socialType, socialId: $socialId, displayName: $displayName, username: $username, email: $email }';
  }
}

enum SocialType { facebook, google }
