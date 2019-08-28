import 'package:crust/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class FeedState {
  final List<Post> posts;

  FeedState({this.posts});

  FeedState.initialState()
    : posts = List<Post>();

  FeedState copyWith({List<Post> posts}) {
    return FeedState(
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return '''{ posts: ${posts != null ? posts.length : null} }''';
  }
}
