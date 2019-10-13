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
  final DateTime repliedAt;

  Reply({this.id, this.commentId, this.body, this.likedByUsers, this.likedByStores, this.repliedBy, this.repliedByStore, this.repliedAt});

  factory Reply.fromToaster(Map<String, dynamic> reply) {
    if (reply == null) return null;
    var repliedBy = reply['replied_by'];
    var repliedByStore = reply['replied_by_store'];
    return Reply(
      id: reply['id'],
      commentId: reply['comment_id'],
      body: reply['body'],
      likedByUsers: List<int>.from(reply['likes'].map((l) => l['user_id']).where((id) => id != null)),
      likedByStores: List<int>.from(reply['likes'].map((l) => l['store_id']).where((id) => id != null)),
      repliedBy: repliedBy != null ? User.fromProfileToaster(repliedBy) : null,
      repliedByStore: repliedByStore != null ? Store.fromToaster(repliedByStore) : null,
      repliedAt: DateTime.parse(reply['replied_at']),
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
      profile_picture
    },
    replied_by_store {
      name,
      cover_image,
    },
    replied_at
  """;

  String replyTo() {
    if (repliedBy != null) {
      return '${repliedBy.displayName} @${repliedBy.username}';
    }
    return repliedByStore.name;
  }
}
