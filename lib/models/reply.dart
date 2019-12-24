import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';

class Reply {
  final int id;
  final int commentId;
  final String body;
  final List<int> likedByUsers;
  final List<int> likedByStores;
  final User repliedBy;
  final Store repliedByStore;
  final int replyTo;
  final DateTime repliedAt;

  Reply({this.id, this.commentId, this.body, this.likedByUsers, this.likedByStores, this.repliedBy, this.repliedByStore, this.replyTo, this.repliedAt});

  factory Reply.fromToaster(Map<String, dynamic> json) {
    if (json == null) return null;
    var repliedBy = json['replied_by'];
    var repliedByStore = json['replied_by_store'];
    var replyTo = json['replyTo'];
    return Reply(
      id: json['id'],
      commentId: json['comment_id'],
      body: json['body'],
      likedByUsers: List<int>.from(json['likes'].map((l) => l['user_id']).where((id) => id != null)),
      likedByStores: List<int>.from(json['likes'].map((l) => l['store_id']).where((id) => id != null)),
      repliedBy: repliedBy != null ? User.fromProfileToaster(repliedBy) : null,
      repliedByStore: repliedByStore != null ? Store.fromToaster(repliedByStore) : null,
      replyTo: replyTo != null ? replyTo['user_id'] : null,
      repliedAt: DateTime.parse(json['replied_at']),
    );
  }

  static const attributes = """
    id,
    comment_id,
    body,
    likes {
      user_id,
      store_id,
    },
    replied_by {
      user_id,
      username,
      preferred_name,
      profile_picture,
      admin {
        store_id,
      }
    },
    replied_by_store {
      id,
      name,
      cover_image,
    },
    reply_to {
      user_id,
    },
    replied_at,
  """;

  String getReplyTo() {
    if (repliedByStore != null) {
      return repliedByStore.name;
    }
    return '${repliedBy.displayName} @${repliedBy.username}';
  }
}
