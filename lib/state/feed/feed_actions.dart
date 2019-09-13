import 'package:crust/models/post.dart';

class InitFeed {}

class FetchFeedSuccess {
  final List<Post> posts;

  FetchFeedSuccess(this.posts);
}

class RemoveFeedPost {
  final int postId;

  RemoveFeedPost(this.postId);
}

class ClearFeed {}
