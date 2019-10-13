import 'dart:collection';

import 'package:crust/models/comment.dart';
import 'package:crust/models/reply.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class CommentState {
  final LinkedHashMap<int, LinkedHashMap<int, Comment>> comments;

  CommentState({this.comments});

  CommentState.initialState()
      : comments = LinkedHashMap<int, LinkedHashMap<int, Comment>>();

  CommentState copyWith({
    LinkedHashMap<int, LinkedHashMap<int, Comment>> comments,
  }) {
    return CommentState(
      comments: comments ?? this.comments,
    );
  }

  CommentState addComments(int postId, List<Comment> comments) {
    var clone = cloneComments();
    var newComments = LinkedHashMap<int, Comment>.fromEntries(comments.map((c) => MapEntry(c.id, c)));
    clone[postId] = newComments;
    return copyWith(comments: clone);
  }

  CommentState favoriteComment(int myId, Comment comment) {
    var clone = cloneComments();
    clone[comment.postId][comment.id].likedByUsers.add(myId);
    return copyWith(comments: clone);
  }

  CommentState unfavoriteComment(int myId, Comment comment) {
    var clone = cloneComments();
    clone[comment.postId][comment.id].likedByUsers.remove(myId);
    return copyWith(comments: clone);
  }

  CommentState favoriteReply(int myId, int postId, Reply reply) {
    var clone = cloneComments();
    clone[postId][reply.commentId].replies[reply.id].likedByUsers.add(myId);
    return copyWith(comments: clone);
  }

  CommentState unfavoriteReply(int myId, int postId, Reply reply) {
    var clone = cloneComments();
    clone[postId][reply.commentId].replies[reply.id].likedByUsers.remove(myId);
    return copyWith(comments: clone);
  }

  LinkedHashMap<int, LinkedHashMap<int, Comment>> cloneComments() {
    return LinkedHashMap<int, LinkedHashMap<int, Comment>>.from(this.comments);
  }

  @override
  String toString() {
    return '''{ comments: ${comments.length} }''';
  }

}
