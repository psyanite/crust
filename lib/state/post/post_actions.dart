import 'package:crust/models/post.dart';

class FetchPostsForUserRequested {
  final int userId;

  FetchPostsForUserRequested(this.userId);

  @override
  String toString() {
    return 'RequestFailure';
  }
}

class FetchPostsForUserSuccess {
  final List<Post> posts;

  FetchPostsForUserSuccess(this.posts);

  @override
  String toString() {
    return 'RequestFailure';
  }
}
