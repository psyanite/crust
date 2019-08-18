import 'package:crust/models/post.dart';

class FetchDefaultFeed {}

class FetchFeed {
  final int userId;

  FetchFeed(this.userId);
}

class FetchFeedSuccess {
  final Set<Post> posts;

  FetchFeedSuccess(this.posts);
}
