import 'package:crust/models/user.dart';
import 'package:crust/models/Post.dart';
import 'package:meta/meta.dart';

@immutable
class MeState {
  final User me;
  final List<Post> posts;

  MeState({
    this.me,
    this.posts,
  });

  MeState copyWith({User me, List<Post> posts}) {
    return new MeState(
      me: me ?? this.me,
      posts: posts ?? this.posts,
    );
  }

  factory MeState.rehydrate(Map<String, dynamic> json) => new MeState(
    me: json['me'] == null ? null : new User.rehydrate(json['me']),
  );

  Map<String, dynamic> toPersist() => <String, dynamic>{
    'me': this.me == null ? null : this.me.toPersist(),
  };

  @override
  String toString() {
    return '''{
        me: $me,
        posts: $posts,
      }''';
  }
}
