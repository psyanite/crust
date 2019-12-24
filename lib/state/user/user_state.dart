import 'dart:collection';

import 'package:crust/models/user.dart';
import 'package:meta/meta.dart';

@immutable
class UserState {
  final LinkedHashMap<int, User> users;

  UserState({this.users});

  UserState.initialState()
    : users = LinkedHashMap<int, User>();

  UserState copyWith({LinkedHashMap<int, User> users}) {
    return UserState(
      users: users ?? this.users,
    );
  }

  UserState addUser(User user) {
    var clone = cloneUsers();
    clone[user.id] = user;
    return copyWith(users: clone);
  }

  LinkedHashMap<int, User> cloneUsers() {
    return LinkedHashMap<int, User>.from(this.users);
  }

  @override
  String toString() {
    return '{ users: ${users != null ? users.length : null} }';
  }
}
