class ServerException implements Exception {
  final String message;
  final int? statusCode;

  ServerException({required this.message, this.statusCode});
}

class NetworkException implements Exception {}

class RateLimitException implements Exception {
  final String message;
  RateLimitException({this.message = 'Too many requests. Please wait.'});
}
