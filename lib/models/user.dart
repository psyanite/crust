import 'package:crust/models/post.dart';
import 'package:crust/utils/enum_util.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User {
  final int id;
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
  final List<Post> posts;

  User({
    this.id,
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
    this.posts,
  });

  User copyWith({int id, String username, String profilePicture, String displayName, List<Post> posts, String tagline}) {
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
      posts: posts ?? this.posts,
    );
  }

  User setTagline(String tagline) {
    return User(
      id: id,
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
    );
  }

  factory User.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
      id: json['id'],
      email: json['email'],
      username: json['profile']['username'],
      displayName: json['profile']['preferred_name'],
      profilePicture: json['profile']['profile_picture'],
      tagline: json['profile']['tagline'],
      posts: json['posts'] != null ? (json['posts'] as List).map((p) => Post.fromToaster(p)).toList() : null,
    );
  }

  factory User.fromProfileToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
      id: json['user_id'],
      username: json['username'],
      displayName: json['preferred_name'],
      profilePicture: json['profile_picture'],
      tagline: json['tagline'],
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

  @override
  String toString() {
    return '{ id: $id, socialType: $socialType, socialId: $socialId, displayName: $displayName, username: $username, email: $email }';
  }
}

enum SocialType { facebook, google }
