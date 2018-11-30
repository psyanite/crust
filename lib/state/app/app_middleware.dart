import 'package:crust/state/app/app_state.dart';
import 'package:crust/state/home/home_middleware.dart';
import 'package:crust/state/me/me_middleware.dart';
import 'package:crust/state/user/user_middleware.dart';
import 'package:redux/redux.dart';

List<Middleware<AppState>> createAppMiddleware() {
  return <Middleware<AppState>>[]..addAll(createHomeMiddleware())..addAll(createMeMiddleware())..addAll(createUserMiddleware());
}
