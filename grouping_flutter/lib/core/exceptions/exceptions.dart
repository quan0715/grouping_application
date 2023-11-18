class ServerException implements Exception{
  final String exceptionMessage;
  final String exceptionType = 'ServerException';
  ServerException({required this.exceptionMessage});

  @override
  String toString() {
    return '($exceptionType) exception raise: $exceptionMessage';
  }
}

class CacheException implements Exception{
  final String exceptionMessage;
  final String exceptionType = 'CacheException';
  CacheException({required this.exceptionMessage});

  @override
  String toString() {
    return '($exceptionType) exception raise: $exceptionMessage';
  }
}