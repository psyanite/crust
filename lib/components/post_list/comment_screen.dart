import 'package:crust/components/confirm.dart';
import 'package:crust/components/post_list/comment_like_button.dart';
import 'package:crust/components/post_list/reply_like_button.dart';
import 'package:crust/models/comment.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/reply.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/comment/comment_actions.dart';
import 'package:crust/state/comment/comment_service.dart';
import 'package:crust/utils/time_util.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class CommentScreen extends StatelessWidget {
  final Post post;

  CommentScreen({Key key, this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _Props>(
        onInit: (Store<AppState> store) {
          store.dispatch(FetchCommentsRequest(post.id));
        },
        converter: (Store<AppState> store) => _Props.fromStore(store, post.id),
        builder: (BuildContext context, _Props props) => _Presenter(
              postId: post.id,
              comments: props.comments,
              myId: props.myId,
            ));
  }
}

class _Presenter extends StatefulWidget {
  final int postId;
  final List<Comment> comments;
  final int myId;

  _Presenter({Key key, this.postId, this.comments, this.myId}) : super(key: key);

  @override
  _PresenterState createState() => _PresenterState(comments: comments);
}

class _PresenterState extends State<_Presenter> {
  List<Comment> comments;
  TextEditingController _bodyCtrl = TextEditingController();
  ScrollController _scrollCtrl = ScrollController();
  String _body = '';
  FocusNode _bodyFocus;
  Form _form = Form(type: FormType.comment);
  bool _enableSubmit = false;
  User _replyTo;
  bool _flashReplyTo = false;

  bool _showNewCommentLoader = false;

  int _flashComment;
  Reply _newReply;

  _PresenterState({this.comments});

  @override
  initState() {
    super.initState();
    _bodyFocus = FocusNode();
  }

  @override
  void didUpdateWidget(_Presenter old) {
    if (old.comments != widget.comments) {
      comments = widget.comments;
    }
    super.didUpdateWidget(old);
  }

  @override
  dispose() {
    _bodyCtrl.dispose();
    _bodyFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var slivers = <Widget>[
      _appBar(context),
      _content(),
      if (_showNewCommentLoader) _newCommentLoader(),
    ];
    return Scaffold(
        body: Column(children: <Widget>[
      Flexible(child: CustomScrollView(controller: _scrollCtrl, slivers: slivers)),
      Container(
        decoration: BoxDecoration(color: Burnt.paper),
        child: _composer(),
      )
    ]));
  }

  Widget _appBar(context) {
    return SliverSafeArea(
      sliver: SliverToBoxAdapter(
          child: Container(
        padding: EdgeInsets.only(left: 16.0, right: 16.0, top: 35.0, bottom: 2.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(width: 50.0, height: 60.0),
                Positioned(
                  left: -12.0,
                  child: IconButton(
                    icon: Icon(CrustCons.back, color: Burnt.lightGrey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
              ],
            ),
            Text('COMMENTS', style: Burnt.appBarTitleStyle.copyWith(fontSize: 22.0)),
          ],
        ),
      )),
    );
  }

  Widget _newCommentLoader() {
    return SliverToBoxAdapter(
      child: Container(
          height: 100,
          child: Center(
            child: CircularProgressIndicator(),
          )),
    );
  }

  Widget _noComments() {
    return CenterTextSliver(text: 'Looks like there aren\'t any comments yet.\nBe the first to add one!');
  }

  Widget _content() {
    if (comments == null) return LoadingSliver();
    if (comments.isEmpty) return _noComments();
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, i) {
        var comment = comments[i];
        return _CommentCard(
          postId: widget.postId,
          comment: comment,
          setReplyToComment: _setReplyToComment,
          removeComment: _removeComment,
          myId: widget.myId,
          flash: _flashComment == comment.id,
          newReply: (_newReply != null && _newReply.commentId == comment.id) ? _newReply : null,
        );
      }, childCount: comments.length),
    );
  }

  Widget _replyToField() {
    var text = _replyTo != null ? 'Reply to ${_replyTo.displayName} @${_replyTo.username}' : 'Reply to post';
    return Builder(builder: (context) => Container(
      height: 25.0,
      child: Row(
        children: <Widget>[
          Text(text, style: TextStyle(color: _flashReplyTo ? Burnt.blue : Burnt.hintTextColor, fontSize: 13.0)),
          _replyTo != null
              ? InkWell(
                  onTap: () => _setCommentToPost(context),
                  child: Container(
                      child: Padding(
                    padding: EdgeInsets.only(left: 3.0, right: 3.0, bottom: 1.0, top: 3.0),
                    child: Icon(CupertinoIcons.clear_thick_circled, size: 20.0, color: Burnt.lightGrey),
                  )),
                )
              : Container()
        ],
      ),
    ),
    );
  }

  Widget _composer() {
    return Builder(
      builder: (context) => Card(
        color: Color(0xFFFDFDFD),
        elevation: 24.0,
        margin: EdgeInsets.all(0.0),
        child: Container(
          padding: EdgeInsets.only(left: 20.0),
          decoration: BoxDecoration(border: Border.all(color: Colors.transparent)),
          child: Row(
            children: <Widget>[
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _replyToField(),
                    _bodyTextField(context),
                    Container(height: 10.0),
                  ],
                ),
              ),
              InkWell(
                  highlightColor: Colors.transparent,
                  child: Container(
                      padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 16.0, right: 20.0),
                      child: Text("Submit", style: TextStyle(color: _enableSubmit ? Burnt.primary : Burnt.lightBlue))),
                  onTap: () => _handleSubmit(context, _bodyCtrl.text)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _bodyTextField(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      reverse: true,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: 50.0,
        ),
        child: TextField(
          focusNode: _bodyFocus,
          controller: _bodyCtrl,
          onChanged: _onBodyChange,
          onSubmitted: (text) => _handleSubmit(context, text),
          autofocus: true,
          maxLines: null,
          decoration: InputDecoration(contentPadding: EdgeInsets.all(0.0), border: InputBorder.none),
        ),
      ),
    );
  }

  _onBodyChange(String text) {
    setState(() {
      _body = text;
      _enableSubmit = text.trim().isNotEmpty;
    });
  }

  _doFlashReplyToField() {
    setState(() => _flashReplyTo = true);
    Future.delayed(Duration(milliseconds: 1000), () => setState(() => _flashReplyTo = false));
  }

  _scrollToBottom() {
    _scrollCtrl.jumpTo(_scrollCtrl.position.maxScrollExtent);
  }

  _handleSubmit(BuildContext context, String text) {
    if (widget.myId == null) snack(context, 'Login now to add comments');
    if (!_enableSubmit) return;
    _form.type == FormType.comment ? _addComment() : _addReply();
    FocusScope.of(context).requestFocus(FocusNode());
    _bodyCtrl.clear();
    setState(() => _body = '');
  }

  _addComment() async {
    _scrollToBottom();
    this.setState(() => _showNewCommentLoader = true);
    var newComment = await CommentService.addComment(Comment(body: _body, postId: widget.postId, commentedBy: User(id: widget.myId)));
    this.setState(() => _showNewCommentLoader = false);
    if (newComment != null) {
      this.setState(() {
        comments = List.from(comments)..add(newComment);
        _flashComment = newComment.id;
      });
    }
    _scrollToBottom();
  }

  _addReply() async {
    var body = _replyTo != null ? "@${_replyTo.username} $_body" : _body;
    var newReply = await CommentService.addReply(Reply(body: body, commentId: _form.commentId, repliedBy: User(id: widget.myId)));
    if (newReply != null) this.setState(() => _newReply = newReply);
  }

  _removeComment(Comment comment) {
    this.setState(() => comments = List.from(comments)..remove(comment));
  }

  _setCommentToPost(BuildContext context) {
    setState(() {
      _form = Form(type: FormType.comment);
      _replyTo = null;
    });
    FocusScope.of(context).requestFocus(_bodyFocus);
    _doFlashReplyToField();
  }

  _setReplyToComment(int commentId, User replyTo) {
    setState(() {
      _form = Form(type: FormType.reply, commentId: commentId);
      _replyTo = replyTo;
    });
    FocusScope.of(context).requestFocus(_bodyFocus);
    _doFlashReplyToField();
  }
}

class _CommentCard extends StatefulWidget {
  final int postId;
  final Comment comment;
  final Function setReplyToComment;
  final Function removeComment;
  final int myId;
  final bool flash;
  final Reply newReply;

  _CommentCard({Key key, this.postId, this.comment, this.setReplyToComment, this.removeComment, this.myId, this.flash, this.newReply})
      : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> with TickerProviderStateMixin {
  bool _showReplies = false;
  AnimationController _colorCtrl;
  Animation<Color> _colorTween;

  @override
  initState() {
    super.initState();
    _colorCtrl = AnimationController(duration: Duration(seconds: 1), vsync: this);
    _colorTween = ColorTween(begin: widget.flash ? Burnt.primaryLight : Burnt.paper).animate(_colorCtrl);
    if (widget.flash) _colorCtrl.forward();
  }

  @override
  dispose() {
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Container(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: () async {
                if (widget.myId != widget.comment.commentedBy.id) return;
                _colorTween = ColorTween(begin: Burnt.primaryLight).animate(_colorCtrl);
                Future.delayed(Duration(milliseconds: 500), () {
                  var deleteComment = () async {
                    var success = await CommentService.deleteComment(userId: widget.myId, comment: widget.comment);
                    if (success == true) {
                      widget.removeComment(widget.comment);
                      snack(context, 'Comment deleted successfully');
                    }
                  };
                  showDialog(context: context, builder: (context) => _deleteDialog(context, deleteComment));
                });
                await _colorCtrl.forward();
                _colorTween = ColorTween(begin: Burnt.paper).animate(_colorCtrl);
                _colorCtrl.reset();
              },
              child: Container(
                color: _colorTween.value,
                padding: EdgeInsets.only(top: 10.0, left: 16.0, right: 16.0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  _profilePicture(widget.comment.commentedBy.profilePicture),
                  _body(),
                ]),
              ),
            ),
          ),
    );
  }

  Widget _body() {
    var comment = widget.comment;
    var commentedAt = TimeUtil.format(comment.commentedAt);
    return Flexible(
      child: Padding(
        padding: EdgeInsets.only(left: 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(comment.commentedBy.displayName, style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(' @${comment.commentedBy.username}', style: TextStyle(color: Burnt.hintTextColor, fontSize: 15.0)),
                          ],
                        ),
                        Text(comment.body),
                        Row(
                          children: <Widget>[
                            Text('$commentedAt ·', style: TextStyle(color: Burnt.lightTextColor, fontSize: 15.0)),
                            InkWell(
                              splashColor: Burnt.primaryLight,
                              onTap: _onTapReply,
                              child: Container(
                                padding: EdgeInsets.only(top: 3.0, bottom: 3.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(' Reply', style: TextStyle(color: Burnt.lightTextColor, fontSize: 15.0)),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  CommentLikeButton(comment: comment)
                ],
              ),
            ),
            comment.replies.isNotEmpty ? _replyTeaser() : Container(height: 15.0),
            if (comment.replies.isNotEmpty && _showReplies)
              _Replies(
                postId: widget.postId,
                replies: comment.replies.values.toList(),
                myId: widget.myId,
                setReplyToComment: widget.setReplyToComment,
                newReply: widget.newReply,
              ),
          ],
        ),
      ),
    );
  }

  Widget _replyTeaser() {
    var text = _showReplies ? 'Hide replies' : 'Show ${widget.comment.replies.length} replies';
    return Flexible(
      child: Builder(
        builder: (context) => InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 7.0),
                child: Row(children: <Widget>[
                  Expanded(child: Divider()),
                  Container(width: 15.0),
                  Text(text, style: TextStyle(color: Burnt.hintTextColor, fontSize: 15.0)),
                  Container(width: 15.0),
                  Expanded(child: Divider()),
                ]),
              ),
              onTap: () => this.setState(() => _showReplies = !_showReplies),
            ),
      ),
    );
  }

  _onTapReply() {
    widget.setReplyToComment(widget.comment.id, widget.comment.commentedBy);
  }
}

class _Replies extends StatefulWidget {
  final int postId;
  final List<Reply> replies;
  final int myId;
  final Function setReplyToComment;
  final Reply newReply;

  _Replies({Key key, this.postId, this.replies, this.myId, this.setReplyToComment, this.newReply}) : super(key: key);

  @override
  _RepliesState createState() => _RepliesState(replies: replies);
}

class _RepliesState extends State<_Replies> {
  List<Reply> replies;
  bool _showReplies = false;
  int _flashReply;

  _RepliesState({this.replies});

  @override
  void didUpdateWidget(_Replies old) {
    if (old.newReply != widget.newReply) {
      replies = List.from(replies)..add(widget.newReply);
      _flashReply = widget.newReply.id;
    }
    super.didUpdateWidget(old);
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: ListView.builder(
            padding: EdgeInsets.only(top: 5.0, bottom: 15.0),
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: replies.length,
            itemBuilder: (context, i) {
              var reply = replies[i];
              return _ReplyCard(
                postId: widget.postId,
                reply: reply,
                myId: widget.myId,
                flash: _flashReply == reply.id,
                onTapReply: _onTapReply,
                removeReply: _removeReply,
              );
            }));
  }

  _removeReply(Reply reply) {
    this.setState(() => replies = List.from(replies)..remove(reply));
  }

  _onTapReply(Reply reply) {
    widget.setReplyToComment(reply.commentId, reply.repliedBy);
  }
}

class _ReplyCard extends StatefulWidget {
  final int postId;
  final Reply reply;
  final int myId;
  final bool flash;
  final Function onTapReply;
  final Function removeReply;

  _ReplyCard({Key key, this.postId, this.reply, this.myId, this.flash, this.onTapReply, this.removeReply}) : super(key: key);

  @override
  _ReplyCardState createState() => _ReplyCardState();
}

class _ReplyCardState extends State<_ReplyCard> with TickerProviderStateMixin {
  AnimationController _colorCtrl;
  Animation<Color> _colorTween;

  @override
  initState() {
    super.initState();
    _colorCtrl = AnimationController(duration: Duration(seconds: 1), vsync: this);
    _colorTween = ColorTween(begin: widget.flash ? Burnt.primaryLight : Burnt.paper).animate(_colorCtrl);
    if (widget.flash) _colorCtrl.forward();
  }

  @override
  dispose() {
    _colorCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: _colorTween,
        builder: (context, child) => Container(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onLongPress: () async {
                  if (widget.myId != widget.reply.repliedBy.id) return;
                  _colorTween = ColorTween(begin: Burnt.primaryLight).animate(_colorCtrl);
                  Future.delayed(Duration(milliseconds: 500), () {
                    var deleteReply = () async {
                      var success = await CommentService.deleteReply(userId: widget.myId, reply: widget.reply);
                      if (success == true) {
                        widget.removeReply(widget.reply);
                        snack(context, 'Comment deleted successfully');
                      }
                    };
                    showDialog(context: context, builder: (context) => _deleteDialog(context, deleteReply));
                  });
                  await _colorCtrl.forward();
                  _colorTween = ColorTween(begin: Burnt.paper).animate(_colorCtrl);
                  _colorCtrl.reset();
                },
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 7.0),
                  color: _colorTween.value,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                    _profilePicture(widget.reply.repliedBy.profilePicture),
                    body(),
                    ReplyLikeButton(postId: widget.postId, reply: widget.reply),
                  ]),
                ),
              ),
            ));
  }

  Widget body() {
    var reply = widget.reply;
    var repliedAt = TimeUtil.format(reply.repliedAt);
    return Expanded(
      flex: 1,
      child: Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text(reply.repliedBy.displayName, style: TextStyle(fontWeight: FontWeight.bold)),
                Text(' @${reply.repliedBy.username}', style: TextStyle(color: Burnt.hintTextColor, fontSize: 15.0)),
              ],
            ),
            _bodyText(reply.body),
            Row(
              children: <Widget>[
                Text('$repliedAt ·', style: TextStyle(color: Burnt.lightTextColor, fontSize: 15.0)),
                InkWell(
                    splashColor: Burnt.primaryLight,
                    onTap: () => widget.onTapReply(reply),
                    child: Text(' Reply', style: TextStyle(color: Burnt.lightTextColor, fontSize: 15.0))),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _bodyText(String body) {
    if (body.startsWith('@') && body.indexOf(" ") > 0) {
      var mention = body.split(" ")[0];
      var content = body.substring(body.indexOf(" "));
      return RichText(
          text: TextSpan(
        style: TextStyle(color: Burnt.textBodyColor, fontFamily: Burnt.fontBase),
        children: <TextSpan>[
          TextSpan(text: mention, style: TextStyle(color: Burnt.darkBlue)),
          TextSpan(text: content),
        ],
      ));
    } else {
      return Text(body);
    }
  }
}

Widget _profilePicture(String image) {
  return Padding(
    padding: EdgeInsets.only(top: 3.0),
    child: Container(
        width: 30.0,
        height: 30.0,
        decoration: BoxDecoration(color: Burnt.imgPlaceholderColor, image: DecorationImage(fit: BoxFit.cover, image: NetworkImage(image)))),
  );
}

Widget _deleteDialog(BuildContext context, Function delete) {
  return Confirm(
      title: 'Would you like to delete your comment?',
      description: 'This comment will be lost forever.',
      action: 'Delete',
      onTap: () {
        delete();
        Navigator.of(context, rootNavigator: true).pop(true);
      });
}

class _Props {
  final int myId;
  final List<Comment> comments;

  _Props({this.myId, this.comments});

  static fromStore(Store<AppState> store, int postId) {
    return _Props(
      myId: store.state.me.user?.id,
      comments: store.state.comment.comments[postId]?.values?.toList(),
    );
  }
}

enum FormType { reply, comment }

class Form {
  final FormType type;
  final int commentId;

  Form({
    this.type,
    this.commentId,
  });
}
