import 'dart:collection';

import 'package:crust/models/reply.dart';
import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';

class Comment {
  final int id;
  final int postId;
  final String body;
  final LinkedHashMap<int, Reply> replies;
  final List<int> likedByUsers;
  final List<int> likedByStores;
  final User commentedBy;
  final Store commentedByStore;
  final DateTime commentedAt;

  Comment({this.id, this.postId, this.body, this.replies, this.likedByUsers, this.likedByStores, this.commentedBy, this.commentedByStore, this.commentedAt});

  Comment copyWith({LinkedHashMap<int, Reply> replies}) {
    return Comment(
      id: id,
      postId: postId,
      body: body,
      replies: replies ?? this.replies,
      likedByUsers: likedByUsers,
      likedByStores: likedByStores,
      commentedBy: commentedBy,
      commentedByStore: commentedByStore,
      commentedAt: commentedAt,
    );
  }

  factory Comment.fromToaster(Map<String, dynamic> comment) {
    if (comment == null) return null;
    var commentedBy = comment['commented_by'];
    var commentedByStore = comment['commented_by_store'];
    var replies = comment['replies'] != null ? (comment['replies'] as List).map<Reply>((r) => Reply.fromToaster(r)).toList() : [];
    return Comment(
      id: comment['id'],
      postId: comment['post_id'],
      body: comment['body'],
      likedByUsers: List<int>.from(comment['likes'].map((l) => l['user_id']).where((id) => id != null)),
      likedByStores: List<int>.from(comment['likes'].map((l) => l['store_id']).where((id) => id != null)),
      commentedBy: commentedBy != null ? User.fromProfileToaster(commentedBy) : null,
      commentedByStore: commentedByStore != null ? Store.fromToaster(commentedByStore) : null,
      replies: LinkedHashMap<int, Reply>.fromEntries(replies.map((r) => MapEntry<int, Reply>(r.id, r))),
      commentedAt: DateTime.parse(comment['commented_at']),
    );
  }

  static const attributes = """
    id,
    post_id,
    body,
    replies {
      ${Reply.attributes}
    },
    likes {
      user_id,
      store_id,
    },
    commented_by {
      user_id,
      username,
      preferred_name,
      profile_picture
    },
    commented_by_store {
      id,
      name,
      cover_image,
    },
    commented_at,
  """;

  String replyTo() {
    if (commentedByStore != null) {
      return commentedByStore.name;
    }
    return '${commentedBy.displayName} @${commentedBy.username}';
  }
}
