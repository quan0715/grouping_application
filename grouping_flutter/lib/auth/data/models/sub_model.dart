class AuthTokenModel{
  final String _token;
  AuthTokenModel({required String token}): _token = token;
  String get token => _token;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json){
    return AuthTokenModel(token: json['auth-token']);
  }

  static Map<String, dynamic> toJson(AuthTokenModel model){
    return {
      'auth-token': model.token,
    };
  }
}