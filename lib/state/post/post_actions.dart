import 'package:crust/models/post.dart';

class FetchPostsForUserRequest {
  final int userId;

  FetchPostsForUserRequest(this.userId);
}

class FetchPostsForUserSuccess {
  final List<Post> posts;

  FetchPostsForUserSuccess(this.posts);
}
