class RequestFailure {
  final String error;

  RequestFailure(this.error);

  @override
  String toString() {
    return 'RequestFailure';
  }
}

class SendSystemError {
  final String type;
  final String description;
  
  SendSystemError(this.type, this.description);
}
