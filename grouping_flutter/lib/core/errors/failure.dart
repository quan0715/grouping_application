class Failure {
  final String errorMessage;
  
  Failure({required this.errorMessage});
  
  @override
  String toString() => 'Failure: $errorMessage';
}

class ServerFailure extends Failure {
  ServerFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
  
}

class CacheFailure extends Failure {
  CacheFailure({required String errorMessage})
      : super(errorMessage: errorMessage);
}