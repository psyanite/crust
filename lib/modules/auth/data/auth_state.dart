import 'package:crust/modules/auth/models/user.dart';
import 'package:crust/modules/post/models/Post.dart';
import 'package:meta/meta.dart';

@immutable
class AuthState {
  final User user;
  final List<Post> posts;

  AuthState({
    this.user,
    this.posts,
  });

  AuthState copyWith({User user, List<Post> posts}) {
    return new AuthState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
    );
  }

  factory AuthState.fromJson(Map<String, dynamic> json) => new AuthState(
    user: json['user'] == null ? null : new User.fromJson(json['user']),
  );

  Map<String, dynamic> toJson() => <String, dynamic>{
    'user': this.user == null ? null : this.user.toJson(),
  };

  @override
  String toString() {
    return '''{
                user: $user,
                posts: $posts,
            }''';
  }
}
