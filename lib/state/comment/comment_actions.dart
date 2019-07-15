import 'package:crust/models/comment.dart';
import 'package:crust/models/reply.dart';

class FetchCommentsRequest {
  final int postId;

  FetchCommentsRequest(this.postId);
}

class FetchCommentsSuccess {
  final int postId;
  final List<Comment> comments;

  FetchCommentsSuccess(this.postId, this.comments);
}

class FavoriteCommentRequest {
  final Comment comment;

  FavoriteCommentRequest(this.comment);
}

class FavoriteCommentSuccess {
  final int myId;
  final Comment comment;

  FavoriteCommentSuccess(this.myId, this.comment);
}

class UnfavoriteCommentRequest {
  final Comment comment;

  UnfavoriteCommentRequest(this.comment);
}

class UnfavoriteCommentSuccess {
  final int myId;
  final Comment comment;

  UnfavoriteCommentSuccess(this.myId, this.comment);
}

class FavoriteReplyRequest {
  final int postId;
  final Reply reply;

  FavoriteReplyRequest(this.postId, this.reply);
}

class FavoriteReplySuccess {
  final int myId;
  final int postId;
  final Reply reply;

  FavoriteReplySuccess(this.myId, this.postId, this.reply);
}

class UnfavoriteReplyRequest {
  final int postId;
  final Reply reply;

  UnfavoriteReplyRequest(this.postId, this.reply);
}

class UnfavoriteReplySuccess {
  final int myId;
  final int postId;
  final Reply reply;

  UnfavoriteReplySuccess(this.myId, this.postId, this.reply);
}
