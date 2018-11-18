import 'package:crust/modules/post/models/Post.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePostList extends StatelessWidget {
  final List<Post> posts;

  ProfilePostList({Key key, this.posts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: posts.map((p) => _buildPostCard(p)).toList()),
    );
  }

//  Widget _gridSliver(stores) {
//    return SliverGrid(
//      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//        crossAxisCount: 2,
//        childAspectRatio: 1.2,
//        crossAxisSpacing: 5.0,
//        mainAxisSpacing: 5.0,
//      ),
//      delegate: SliverChildListDelegate(List<Widget>.from(stores.map(_storeCard))));
//  }

  Widget _buildPostCard(Post post) {
    return Card(
        child: Column(children: <Widget>[Container(child: Text('store details')), Container(child: Text('ratings')), _buildContent(post)]));
  }

  _buildContent(Post post) {
    return Container(child: Text('content'));
  }
}
