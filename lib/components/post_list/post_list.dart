import 'package:crust/components/post_list/post_card.dart';
import 'package:crust/models/post.dart';
import 'package:crust/components/common/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
          return PostCard(
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

enum PostListType { forStore, forProfile, forFeed }
