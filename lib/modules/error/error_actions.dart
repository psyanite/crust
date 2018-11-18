class RequestFailure {
  final Exception error;

  RequestFailure(this.error);

  @override
  String toString() {
    return 'RequestFailure{error: $error}';
  }
}
