import 'package:crust/models/comment.dart';
import 'package:crust/models/reply.dart';

class FetchComments {
  final int postId;

  FetchComments(this.postId);
}

class FetchCommentsSuccess {
  final int postId;
  final List<Comment> comments;

  FetchCommentsSuccess(this.postId, this.comments);
}

class FavoriteComment {
  final Comment comment;

  FavoriteComment(this.comment);
}

class FavoriteCommentSuccess {
  final int myId;
  final Comment comment;

  FavoriteCommentSuccess(this.myId, this.comment);
}

class UnfavoriteComment {
  final Comment comment;

  UnfavoriteComment(this.comment);
}

class UnfavoriteCommentSuccess {
  final int myId;
  final Comment comment;

  UnfavoriteCommentSuccess(this.myId, this.comment);
}

class FavoriteReply {
  final int postId;
  final Reply reply;

  FavoriteReply(this.postId, this.reply);
}

class FavoriteReplySuccess {
  final int myId;
  final int postId;
  final Reply reply;

  FavoriteReplySuccess(this.myId, this.postId, this.reply);
}

class UnfavoriteReply {
  final int postId;
  final Reply reply;

  UnfavoriteReply(this.postId, this.reply);
}

class UnfavoriteReplySuccess {
  final int myId;
  final int postId;
  final Reply reply;

  UnfavoriteReplySuccess(this.myId, this.postId, this.reply);
}
