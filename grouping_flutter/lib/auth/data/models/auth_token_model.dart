import 'package:jwt_decoder/jwt_decoder.dart';

class AuthTokenModel {
  // the token data model return from server
  // {
  //    "auth-token", $_token
  // }
  final String _token; // token string
  final String _refresh; // refresh token
  final JwtTokenModel? _jwtTokenModel; // token decoded data model

  AuthTokenModel({required String token, required String refresh})
      : _token = token,
        _refresh = refresh,
        _jwtTokenModel = token.isEmpty ? null : JwtTokenModel(token: token);

  String get token => _token;
  String get refresh => _refresh;
  int get userId => _jwtTokenModel?.userId ?? -1;
  bool get isExpired => _jwtTokenModel?.isExpired ?? true;
  bool get isValid =>
      _token.isNotEmpty && _jwtTokenModel != null && !_jwtTokenModel!.isExpired;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) =>
      AuthTokenModel(token: json['auth-token'], refresh: json['refresh-token']);
}

class JwtTokenModel {
  // {
  //  token_type: _tokenType,,
  //  exp: _expirationDate,
  //  iat: _issuedDate,
  //  jti: _jwtTokenId,
  //  user_id: _secreteUserId
  // }
  final String _token;
  final Map<String, dynamic> _decodedToken;
  final JwtSecreteInformation _jwtSecreteInformation;

  JwtTokenModel({required String token})
      : _token = token,
        _decodedToken = JwtDecoder.decode(token),
        _jwtSecreteInformation =
            JwtSecreteInformation(jwtTokenBody: JwtDecoder.decode(token));

  String get token => _token;
  Map<String, dynamic> get decodedToken => _decodedToken;
  int get userId => _jwtSecreteInformation._userId;

  DateTime get expirationDate => JwtDecoder.getExpirationDate(token);
  bool get isExpired => JwtDecoder.isExpired(token);
}

class JwtSecreteInformation {
  final int _userId;
  // In future if any secrete information is needed, add here and add to constructor
  // final String _token;

  JwtSecreteInformation({required Map<String, dynamic> jwtTokenBody})
      : _userId = jwtTokenBody['user_id'];
}
