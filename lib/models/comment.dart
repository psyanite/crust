import 'dart:collection';

import 'package:crust/models/reply.dart';
import 'package:crust/models/user.dart';

class Comment {
  final int id;
  final int postId;
  final String body;
  final LinkedHashMap<int, Reply> replies;
  final List<int> likedBy;
  final User commentedBy;
  final DateTime commentedAt;

  Comment({this.id, this.postId, this.body, this.replies, this.likedBy, this.commentedBy, this.commentedAt});

  Comment copyWith({LinkedHashMap<int, Reply> replies}) {
    return Comment(
      id: id,
      postId: postId,
      body: body,
      replies: replies ?? this.replies,
      likedBy: likedBy,
      commentedBy: commentedBy,
      commentedAt: commentedAt,
    );
  }

  factory Comment.fromToaster(Map<String, dynamic> comment) {
    if (comment == null) return null;
    var commentedBy = comment['commented_by'];
    var replies = comment['replies'] != null ? (comment['replies'] as List).map<Reply>((r) => Reply.fromToaster(r)).toList() : [];
    return Comment(
        id: comment['id'],
        postId: comment['post_id'],
        body: comment['body'],
        likedBy: List<int>.from(comment['liked_by'].map((l) => l['user_id'])),
        commentedBy: commentedBy != null ? User.fromProfileToaster(commentedBy) : null,
        replies: LinkedHashMap<int, Reply>.fromEntries(replies.map((r) => MapEntry<int, Reply>(r.id, r))),
        commentedAt: DateTime.parse(comment['commented_at']));
  }

  static const attributes = """
    id,
    post_id,
    body,
    replies {
      ${Reply.attributes}
    },
    liked_by {
      user_id,
    }
    commented_by {
      user_id,
      username,
      preferred_name,
      profile_picture
    }
    commented_at
  """;
}
