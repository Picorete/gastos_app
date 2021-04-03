abstract class Failure {
  final message;

  Failure(this.message);
}

class ServerFail extends Failure {
  ServerFail(message) : super(message);
}
