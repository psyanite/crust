import 'package:crust/models/user.dart';

class Reply {
  final int id;
  final int commentId;
  final String body;
  final List<int> likedBy;
  final User repliedBy;
  final DateTime repliedAt;

  Reply({this.id, this.commentId, this.body, this.likedBy, this.repliedBy, this.repliedAt});

  factory Reply.fromToaster(Map<String, dynamic> reply) {
    if (reply == null) return null;
    var repliedBy = reply['replied_by'];
    return Reply(
      id: reply['id'],
      commentId: reply['comment_id'],
      body: reply['body'],
      likedBy: List<int>.from((reply['liked_by']).map((l) => l['user_id'])),
      repliedBy: repliedBy != null ? User.fromProfileToaster(repliedBy) : null,
      repliedAt: DateTime.parse(reply['replied_at']),
    );
  }

  static const attributes = """
    id,
    comment_id,
    body,
    liked_by {
      user_id,
    }
    replied_by {
      user_id,
      username,
      preferred_name,
      profile_picture
    }
    replied_at
  """;
}
