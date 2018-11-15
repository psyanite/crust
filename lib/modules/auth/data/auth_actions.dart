import 'package:crust/modules/auth/models/user.dart';

class AddUserRequested {
  final User user;

  AddUserRequested(this.user);
}

class LoginSuccess {
  final User user;

  LoginSuccess(this.user);
}

class LogoutSuccess {}

class Logout {}
