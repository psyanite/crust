import 'package:crust/models/Post.dart';

class FetchPostsForUserRequested {
  final int userAccountId;

  FetchPostsForUserRequested(this.userAccountId);

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
