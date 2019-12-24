import 'package:crust/models/post.dart';
import 'package:crust/models/search.dart';
import 'package:crust/models/user.dart';
import 'package:geocoder/geocoder.dart' as Geo;

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

class SetMyAddress {
  final Geo.Address address;

  SetMyAddress(this.address);
}

class CheckFcmToken {
  CheckFcmToken();
}

class SetFcmToken {
  final String token;

  SetFcmToken(this.token);
}
