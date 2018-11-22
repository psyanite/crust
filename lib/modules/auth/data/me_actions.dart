import 'package:crust/models/user.dart';
import 'package:crust/models/Post.dart';

class AddUserRequested {
  final User user;

  AddUserRequested(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class FetchMyPostsRequest {
  final int userAccountId;

  FetchMyPostsRequest(this.userAccountId);
}

class FetchMyPostsSuccess {
  final List<Post> posts;

  FetchMyPostsSuccess(this.posts);
}

class LogoutSuccess {}

class Logout {}
