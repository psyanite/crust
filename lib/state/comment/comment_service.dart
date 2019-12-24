import 'package:crust/models/comment.dart';
import 'package:crust/models/reply.dart';
import 'package:crust/services/toaster.dart';

class CommentService {
  const CommentService();

  Future<List<Comment>> commentsByPostId(int postId) async {
    String query = """
      query {
        commentsByPostId(postId: $postId) {
          ${Comment.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['commentsByPostId'];
    return (json as List).map((c) => Comment.fromToaster(c)).toList();
  }

  static Future<Comment> addComment(Comment comment) async {
    String query = """
      mutation {
        addComment(postId: ${comment.postId}, body: "${comment.body}", commentedBy: ${comment.commentedBy.id}) {
          ${Comment.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addComment'];
    return Comment.fromToaster(json);
  }

  static Future<bool> deleteComment({ userId, comment }) async {
    String query = """
      mutation {
        deleteComment(myId: $userId, commentId: ${comment.id}) {
          id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deleteComment'];
    return json['id'] == comment.id;
  }

  static Future<Reply> addReply(Reply reply) async {
    String query = """
      mutation {
        addReply(
          commentId: ${reply.commentId}, 
          body: "${reply.body}", 
          replyTo: ${reply.replyTo},
          repliedBy: ${reply.repliedBy.id}
        ) {
          ${Reply.attributes}
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['addReply'];
    return Reply.fromToaster(json);
  }

  static Future<bool> deleteReply({ userId, reply }) async {
    String query = """
      mutation {
        deleteReply(myId: $userId, replyId: ${reply.id}) {
          id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['deleteReply'];
    return json['id'] == reply.id;
  }

  Future<bool> favoriteComment({ userId, commentId }) async {
    String query = """
      mutation {
        favoriteComment(myId: $userId, commentId: $commentId) {
          comment_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoriteComment'];
    return json['comment_id'] == commentId;
  }

  Future<bool> unfavoriteComment({ userId, commentId }) async {
    String query = """
      mutation {
        unfavoriteComment(myId: $userId, commentId: $commentId) {
          comment_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['unfavoriteComment'];
    return json['comment_id'] == commentId;
  }

  Future<bool> favoriteReply({ userId, replyId }) async {
    String query = """
      mutation {
        favoriteReply(myId: $userId, replyId: $replyId) {
          reply_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['favoriteReply'];
    return json['reply_id'] == replyId;
  }

  Future<bool> unfavoriteReply({ userId, replyId }) async {
    String query = """
      mutation {
        unfavoriteReply(myId: $userId, replyId: $replyId) {
          reply_id
        }
      }
    """;
    final response = await Toaster.get(query);
    var json = response['unfavoriteReply'];
    return json['reply_id'] == replyId;
  }
}
