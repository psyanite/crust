import 'package:crust/state/comment/comment_actions.dart';
import 'package:crust/state/comment/comment_state.dart';
import 'package:redux/redux.dart';

Reducer<CommentState> commentReducer = combineReducers([
  new TypedReducer<CommentState, FetchCommentsSuccess>(fetchCommentsSuccess),
  new TypedReducer<CommentState, FavoriteCommentSuccess>(favoriteCommentSuccess),
  new TypedReducer<CommentState, UnfavoriteCommentSuccess>(unfavoriteCommentSuccess),
  new TypedReducer<CommentState, FavoriteReplySuccess>(favoriteReplySuccess),
  new TypedReducer<CommentState, UnfavoriteReplySuccess>(unfavoriteReplySuccess),
]);

CommentState fetchCommentsSuccess(CommentState state, FetchCommentsSuccess action) {
  return state.addComments(action.postId, action.comments);
}

CommentState favoriteCommentSuccess(CommentState state, FavoriteCommentSuccess action) {
  return state.favoriteComment(action.myId, action.comment);
}

CommentState unfavoriteCommentSuccess(CommentState state, UnfavoriteCommentSuccess action) {
  return state.unfavoriteComment(action.myId, action.comment);
}

CommentState favoriteReplySuccess(CommentState state, FavoriteReplySuccess action) {
  return state.favoriteReply(action.myId, action.postId, action.reply);
}

CommentState unfavoriteReplySuccess(CommentState state, UnfavoriteReplySuccess action) {
  return state.unfavoriteReply(action.myId, action.postId, action.reply);
}
