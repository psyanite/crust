import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_actions.dart';
import 'package:crust/state/comment/comment_service.dart';
import 'package:crust/state/error/error_actions.dart';
import 'package:flutter/cupertino.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createCommentMiddleware([
  CommentService service = const CommentService(),
]) {
  final fetchComments = _fetchComments(service);
  final favoriteComment = _favoriteComment(service);
  final unfavoriteComment = _unfavoriteComment(service);
  final favoriteReply = _favoriteReply(service);
  final unfavoriteReply = _unfavoriteReply(service);

  return [
    TypedMiddleware<AppState, FetchComments>(fetchComments),
    TypedMiddleware<AppState, FavoriteComment>(favoriteComment),
    TypedMiddleware<AppState, UnfavoriteComment>(unfavoriteComment),
    TypedMiddleware<AppState, FavoriteReply>(favoriteReply),
    TypedMiddleware<AppState, UnfavoriteReply>(unfavoriteReply),
  ];
}

Middleware<AppState> _fetchComments(CommentService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    service.commentsByPostId(action.postId).then((comments) {
      store.dispatch(FetchCommentsSuccess(action.postId, comments));
    }).catchError((e) => store.dispatch(RequestFailure('fetchComments $e')));

    next(action);
  };
}

Middleware<AppState> _favoriteComment(CommentService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var myId = store.state.me.user.id;
    store.dispatch(FavoriteCommentSuccess(myId, action.comment));
    service.favoriteComment(userId: myId, commentId: action.comment.id).then((success) {
      if (success == false) store.dispatch(RequestFailure('Failed to favorite comment: ${action.comment.id}'));
    }).catchError((e) => store.dispatch(RequestFailure('favoriteComment $e')));
    next(action);
  };
}

Middleware<AppState> _unfavoriteComment(CommentService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var myId = store.state.me.user.id;
    store.dispatch(UnfavoriteCommentSuccess(myId, action.comment));
    service.unfavoriteComment(userId: myId, commentId: action.comment.id).then((success) {
      if (success == false ) store.dispatch(RequestFailure('Failed to unfavorite comment: ${action.comment.id}'));
    }).catchError((e) => store.dispatch(RequestFailure('unfavoriteComment $e')));
    next(action);
  };
}

Middleware<AppState> _favoriteReply(CommentService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var myId = store.state.me.user.id;
    store.dispatch(FavoriteReplySuccess(myId, action.postId, action.reply));
    service.favoriteReply(userId: myId, replyId: action.reply.id).then((success) {
      if (success == false) store.dispatch(RequestFailure('Failed to favorite reply: ${action.reply.id}'));
    }).catchError((e) => store.dispatch(RequestFailure('favoriteReply $e')));
    next(action);
  };
}

Middleware<AppState> _unfavoriteReply(CommentService service) {
  return (Store<AppState> store, action, NextDispatcher next) {
    var myId = store.state.me.user.id;
    store.dispatch(UnfavoriteReplySuccess(myId, action.postId, action.reply));
    service.unfavoriteReply(userId: myId, replyId: action.reply.id).then((success) {
      if (success == false) store.dispatch(RequestFailure('Failed to unfavorite reply: ${action.reply.id}'));
    }).catchError((e) => store.dispatch(RequestFailure('unfavoriteReply $e')));
    next(action);
  };
}
