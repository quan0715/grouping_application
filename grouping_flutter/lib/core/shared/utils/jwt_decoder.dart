import 'package:jwt_decoder/jwt_decoder.dart';

class ServerJwtDecoder{
  final String token;
  const ServerJwtDecoder({required this.token});

  bool isExpired() => JwtDecoder.isExpired(token);

  Map<String, dynamic> decodeToken() => JwtDecoder.decode(token);

  

}