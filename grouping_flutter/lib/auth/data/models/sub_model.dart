import 'package:flutter/material.dart';

class AuthTokenModel {
  final String _token;
  final String _refresh;
  AuthTokenModel({required String token, required String refresh})
      : _token = token,
        _refresh = refresh;
  String get token => _token;
  String get refresh => _refresh;

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) {
    return AuthTokenModel(
        token: json['auth-token'], refresh: json['refresh-token']);
  }

  static Map<String, dynamic> toJson(AuthTokenModel model) {
    return {
      'auth-token': model.token,
      'refresh-token': model.refresh,
    };
  }
}
