import 'package:meta/meta.dart';

@immutable
class ErrorState {
  final String message;

  ErrorState({this.message});

  ErrorState copyWith({String message}) {
    return ErrorState(
      message: message ?? this.message,
    );
  }

  @override
  String toString() {
    return '''{
        message: $message,
      }''';
  }
}
