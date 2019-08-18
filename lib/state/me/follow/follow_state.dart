import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

@immutable
class FollowState {
  final Set<int> stores;
  final Set<int> users;

  FollowState({this.stores, this.users});

  FollowState.initialState()
      : stores = Set<int>(),
        users = Set<int>();

  FollowState copyWith({
    Set<int> stores,
    Set<int> users,
  }) {
    return FollowState(
      stores: stores ?? this.stores,
      users: users ?? this.users,
    );
  }

  @override
  String toString() {
    return '''{
        stores: ${stores != null ? stores.length : null},
        users: ${users != null ? users.length : null},
      }''';
  }
}
