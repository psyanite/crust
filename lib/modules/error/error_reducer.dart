import 'package:crust/modules/error/error_actions.dart';
import 'package:crust/modules/error/error_state.dart';
import 'package:redux/redux.dart';

Reducer<ErrorState> homeReducer = combineReducers([
  new TypedReducer<ErrorState, RequestFailure>(requestFailure),
]);

ErrorState requestFailure(ErrorState state, RequestFailure action) {
  return state.copyWith(message: action.error.toString());
}
