import 'dart:collection';

import 'package:crust/components/post_list/comment_screen.dart';
import 'package:crust/models/comment.dart';
import 'package:crust/services/log.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_actions.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:crust/utils/general_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class HandleNotifyScreen extends StatefulWidget {
  final Map<String, dynamic> notify;

  HandleNotifyScreen({Key key, this.notify}) : super(key: key);

  @override
  _HandleNotifyScreenState createState() => _HandleNotifyScreenState();
}

class _HandleNotifyScreenState extends State<HandleNotifyScreen> {
  _init(Store<AppState> store) {
    _handleNotify(store, widget.notify);
  }

  _handleNotify(Store<AppState> store, Map<String, dynamic> notify) {
    var goto = notify['goto'];
    switch (goto) {
      case 'post':
        _handlePost(store, notify);
        break;

      default:
        Log.error('Could not recognise goto: $goto');
    }
  }

  _handlePost(Store<AppState> store, Map<String, dynamic> notify) async {
    var map = await PostService.fetchPostByIdWithComments(notify['postId']);
    var post = map['post'];
    var comments = List<Comment>.from(map['comments']);
    store.dispatch(FetchCommentsSuccess(post.id, comments));
    var commentMap = LinkedHashMap<int, Comment>.fromEntries(comments.map((c) => MapEntry(c.id, c)));
    var flashComment = Utils.strToInt(notify['flashComment']);
    var flashReply = Utils.strToInt(notify['flashReply']);
    var commentScreen = CommentScreen(
      post: post,
      comments: commentMap,
      showPostCard: true,
      flashComment: flashComment,
      flashReply: flashReply,
    );
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => commentScreen));
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, Store<AppState>>(
      onInit: (store) => _init(store),
      converter: (Store<AppState> store) => store,
      builder: (BuildContext context, Store<AppState> store) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
