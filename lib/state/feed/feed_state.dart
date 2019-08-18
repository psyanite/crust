import 'package:crust/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class FeedState {
  final Set<Post> posts;

  FeedState({this.posts});

  FeedState.initialState()
    : posts = Set<Post>();

  FeedState copyWith({
    Set<Post> posts,
  }) {
    return FeedState(
      posts: posts ?? this.posts,
    );
  }

  @override
  String toString() {
    return '''{
        posts: ${posts != null ? posts.length : null},
      }''';
  }
}
