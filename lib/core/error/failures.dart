import 'package:dartz/dartz.dart';

abstract class Failure {
  const Failure();
}

class DatabaseFailure extends Failure {
  final String message;
  const DatabaseFailure(this.message);
}

class ValidationFailure extends Failure {
  final String message;
  const ValidationFailure(this.message);
}

class GeneralFailure extends Failure {
  final String message;
  const GeneralFailure(this.message);
}
