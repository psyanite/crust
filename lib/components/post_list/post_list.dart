import 'package:crust/components/dialog/confirm.dart';
import 'package:crust/components/common/dialog.dart';
import 'package:crust/components/new_post/edit_post_screen.dart';
import 'package:crust/components/post_list/comment_screen.dart';
import 'package:crust/components/post_list/post_info.dart';
import 'package:crust/components/post_list/post_like_button.dart';
import 'package:crust/models/post.dart';
import 'package:crust/models/user.dart';
import 'package:crust/presentation/components.dart';
import 'package:crust/presentation/crust_cons_icons.dart';
import 'package:crust/presentation/theme.dart';
import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/post/post_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

class PostList extends StatelessWidget {
  final Widget noPostsView;
  final PostListType postListType;
  final List<Post> posts;
  final Function removeFromList;

  PostList({Key key, this.noPostsView, this.postListType, this.posts, this.removeFromList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (posts == null) return LoadingSliverCenter();
    if (posts.isEmpty) return _noPosts();
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate((builder, i) {
          var post = posts[i];
          return _PostCard(
            post: post,
            postListType: postListType,
            removeFromList: () => removeFromList(i, post.id),
          );
        }, childCount: posts.length),
      ),
    );
  }

  Widget _noPosts() {
    return SliverToBoxAdapter(
      child: Container(padding: EdgeInsets.symmetric(vertical: 40.0, horizontal: 16.0), child: Center(child: noPostsView)),
    );
  }
}

class _PostCard extends StatelessWidget {
  final Post post;
  final PostListType postListType;
  final Function removeFromList;

  _PostCard({Key key, this.post, this.postListType, this.removeFromList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PostInfo(post: post, postListType: postListType, buttons: _buttons());
  }

  List<Widget> _buttons() {
    var stuff = <Widget>[
      _postLikeButton(),
      _commentButton(),
    ];
    if (post.hidden == true) stuff.add(_secretIcon());
    stuff.add(_MoreButton(post: post, removeFromList: removeFromList));
    return stuff;
  }

  Widget _postLikeButton() {
    return Padding(
      padding: EdgeInsets.only(top: 2.0),
      child: PostLikeButton(postId: post.id),
    );
  }

  Widget _commentButton() {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 10.0, right: 5.0),
          child: Row(children: <Widget>[
            Icon(CrustCons.post_comment, color: Burnt.iconGrey, size: 28.0),
            Container(width: 3.0),
            if (post.commentCount > 0) Text(post.commentCount.toString(), style: TextStyle(color: Burnt.lightTextColor, fontSize: 15.0)),
          ]),
        ),
        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CommentScreen(post: post))),
      );
    });
  }

  Widget _secretIcon() {
    return Builder(builder: (context) {
      return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 3.0, right: 5.0),
          child: Icon(CrustCons.padlock, color: Burnt.iconGrey, size: 28.0),
        ),
        onTap: () {
          var options = <DialogOption>[DialogOption(display: 'OK', onTap: () => Navigator.of(context, rootNavigator: true).pop(true))];
          showDialog(
            context: context,
            builder: (context) {
              return BurntDialog(
                  options: options, description: 'This post is secret, only you can see it. You can make it public by editing the post.');
            },
          );
        },
      );
    });
  }
}

class _MoreButton extends StatelessWidget {
  final Post post;
  final Function removeFromList;

  _MoreButton({Key key, this.post, this.removeFromList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, dynamic>(converter: (Store<AppState> store) {
      return store.state.me.user;
    }, builder: (context, me) {
      if (me == null || post.postedBy == null || me.id != post.postedBy.id) return Container();
      return _MoreButtonPresenter(removeFromList: removeFromList, post: post, me: me);
    });
  }
}

class _MoreButtonPresenter extends StatelessWidget {
  final Post post;
  final Function removeFromList;
  final User me;

  _MoreButtonPresenter({Key key, this.post, this.removeFromList, this.me}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, top: 10.0, bottom: 10.0, right: 10.0),
          child: Icon(CrustCons.triple_dot, size: 15.0, color: Burnt.lightGrey),
        ),
        onTap: () => _showMoreDialog(context));
  }

  _showMoreDialog(BuildContext context) {
    var closeMoreDialog = () => Navigator.of(context, rootNavigator: true).pop(true);
    showDialog(context: context, builder: (context) => _moreDialog(context, closeMoreDialog));
  }

  Widget _moreDialog(BuildContext context, Function closeMoreDialog) {
    var options = <DialogOption>[
      DialogOption(
        display: 'Edit Post',
        onTap: () {
          closeMoreDialog();
          Navigator.push(context, MaterialPageRoute(builder: (_) => EditPostScreen(post: post)));
        },
      )
    ];
    options.add(
      DialogOption(
        display: 'Delete Post',
        onTap: () {
          showDialog(context: context, builder: (context) => _deleteDialog(context, closeMoreDialog));
        },
      ),
    );
    return BurntDialog(options: options);
  }

  Widget _deleteDialog(BuildContext context, Function closeMoreDialog) {
    return Confirm(
      title: 'Delete Post',
      description: 'This post will be lost forever.',
      action: 'Delete',
      onTap: () async {
        await PostService.deletePost(post.id, me.id);
        removeFromList();
        Navigator.of(context, rootNavigator: true).pop(true);
        closeMoreDialog();
      },
    );
  }
}

enum PostListType { forStore, forProfile, forFeed }
