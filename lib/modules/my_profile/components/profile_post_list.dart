import 'package:crust/modules/post/models/Post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePostList extends StatelessWidget {
  final List<Post> posts;

  ProfilePostList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return posts == null ? _loadingView() : _postList(context);
  }

  Widget _postList(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: posts.map(_buildPostCard)),
    );
  }

  _buildPostCard(Post post) {
    return Card(
        child: Column(children: <Widget>[Container(child: Text('store details')), Container(child: Text('ratings')), _buildContent(post)]));
  }

  _buildContent(Post post) {
    return Container(child: Text('content'));
  }

  Widget _loadingView() {
    return Container(
      child: Center(
        child: CupertinoActivityIndicator(),
      ),
    );
  }
}
