import 'package:crust/models/post.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/store.dart';
import 'package:crust/models/user.dart';

class AddUser {
  final User user;

  AddUser(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class FetchMyPosts {}

class FetchMyPostsSuccess {
  final List<Post> posts;

  FetchMyPostsSuccess(this.posts);
}

class LogoutSuccess {}

class Logout {}

class AddSearchHistoryItem {
  final SearchHistoryItem item;

  AddSearchHistoryItem(this.item);
}

class SetMyLocation {
  final SearchLocationItem location;

  SetMyLocation(this.location);
}

class SetMyTagline {
  final String tagline;

  SetMyTagline(this.tagline);
}

class SetMyTaglineSuccess {
  final String tagline;

  SetMyTaglineSuccess(this.tagline);
}

class DeleteMyTagline {}

class DeleteMyTaglineSuccess {}

class SetMyProfilePicture {
  final String picture;

  SetMyProfilePicture(this.picture);
}

class SetMyDisplayName {
  final String name;

  SetMyDisplayName(this.name);
}

class SetMyUsername {
  final String name;

  SetMyUsername(this.name);
}

class SetMySuburb {
  final Suburb suburb;

  SetMySuburb(this.suburb);
}
