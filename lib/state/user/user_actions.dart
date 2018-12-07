import 'package:crust/models/user.dart';

class FetchUserByUserIdRequest {
  final int userId;

  FetchUserByUserIdRequest(this.userId);
}

class FetchUserByUserIdSuccess {
  final User user;

  FetchUserByUserIdSuccess(this.user);
}
