import 'package:crust/models/post.dart';

class FetchFeed {}

class FetchFeedSuccess {
  final List<Post> posts;

  FetchFeedSuccess(this.posts);
}
