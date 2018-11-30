import 'dart:collection';

import 'package:crust/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final LinkedHashMap<int, User> users;

  UserState({this.users});

  UserState copyWith({LinkedHashMap<int, User> users}) {
    return new UserState(
      users: users ?? this.users,
    );
  }
}
