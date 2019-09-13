import 'dart:collection';

import 'package:crust/models/post.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class FeedState {
  final LinkedHashMap<int, Post> posts;

  FeedState({this.posts});

  FeedState.initialState()
    : posts = LinkedHashMap<int, Post>();

  FeedState copyWith({LinkedHashMap<int, Post> posts}) {
    return FeedState(
      posts: posts ?? this.posts,
    );
  }

  FeedState addPosts(List<Post> posts) {
    return copyWith(posts: clonePosts()..addEntries(posts.map((p) => MapEntry<int, Post>(p.id, p))));
  }

  FeedState removePost(int postId) {
    return copyWith(posts: clonePosts()..remove(postId));
  }

  LinkedHashMap<int, Post> clonePosts() {
    return LinkedHashMap<int, Post>.from(this.posts);
  }

  @override
  String toString() {
    return '''{ posts: ${posts != null ? posts.length : null} }''';
  }
}
