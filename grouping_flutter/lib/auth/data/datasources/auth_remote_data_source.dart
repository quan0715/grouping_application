import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/auth_token_model.dart';
import 'package:grouping_project/auth/domain/entities/code_entity.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/auth/utils/auth_helpers.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource {
  Future<AuthTokenModel> passwordLogin(LoginEntity loginEntity);
  Future<AuthTokenModel> register(RegisterEntity registerEntity);
  Future<AuthTokenModel> thridPartyTokenExchange(CodeEntity codeEntity);
  Future<void> logout(AuthTokenModel authTokenModel);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<AuthTokenModel> passwordLogin(LoginEntity loginEntity) async {
    try {
      String endPoint = EndPointGetter.getAuthBackendEndpoint('signin');

      Map<String, String> body = {
        'account': loginEntity.email,
        'password': loginEntity.password,
      };
      final response = await http.post(Uri.parse(endPoint), body: body);

      int statusCode = response.statusCode;
      // debugPrint('statusCode: $statusCode');
      // debugPrint('qqqqqqq: ${response.body}');
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (statusCode == 200) {
        AuthTokenModel authTokenModel = AuthTokenModel.fromJson(jsonData);
        return authTokenModel;
      } else if (statusCode == 401) {
        throw ServerException(exceptionMessage: jsonData['error']);
      } else {
        throw ServerException(exceptionMessage: 'response status: $statusCode');
      }
    } catch (e) {
      // debugPrint(e.toString());
      throw ServerException(
        exceptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthTokenModel> register(RegisterEntity entity) async {
    try {
      String endPoint = EndPointGetter.getAuthBackendEndpoint('register');
      Map<String, String> body = {
        'account': entity.email,
        'password': entity.password,
        'username': entity.userName,
      };
      final response = await http.post(
        Uri.parse(endPoint),
        body: body,
      );

      int statusCode = response.statusCode;
      debugPrint('statusCode: $statusCode');
      // debugPrint(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (statusCode == 200) {
        AuthTokenModel authTokenModel = AuthTokenModel.fromJson(jsonData);
        return authTokenModel;
      } else if (statusCode == 401) {
        throw ServerException(exceptionMessage: jsonData['error']);
      } else {
        throw ServerException(exceptionMessage: 'response status: $statusCode');
      }
    } catch (e) {
      // debugPrint(e.toString());
      throw ServerException(
        exceptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<AuthTokenModel> thridPartyTokenExchange(CodeEntity codeEntity) async {
    // TODO: implement thridPartyTokenExchange
    try {
      String endPoint =
          EndPointGetter.getAuthBackendEndpoint(codeEntity.authProvider.string);
      Map<String, String> body = {"code": codeEntity.code};
      final response = await http.post(
        Uri.parse(endPoint),
        body: body,
      );

      int statusCode = response.statusCode;
      debugPrint('statusCode: $statusCode');
      // debugPrint(response.body);
      Map<String, dynamic> jsonData = json.decode(response.body);
      if (statusCode == 200) {
        AuthTokenModel authTokenModel = AuthTokenModel.fromJson(jsonData);
        return authTokenModel;
      } else if (statusCode == 401) {
        throw ServerException(exceptionMessage: jsonData['error']);
      } else {
        throw ServerException(exceptionMessage: 'response status: $statusCode');
      }
    } catch (e) {
      // debugPrint(e.toString());
      throw ServerException(
        exceptionMessage: e.toString(),
      );
    }
  }

  @override
  Future<void> logout(AuthTokenModel authTokenModel) async {
    try {
      String endPoint = EndPointGetter.getAuthBackendEndpoint('logout');

      Map<String, String> headers = {
        "Authorization": "Bearer ${authTokenModel.token}",
      };
      Map<String, String> body = {'refresh_token': authTokenModel.refresh};

      final response =
          await http.post(Uri.parse(endPoint), body: body, headers: headers);

      int statusCode = response.statusCode;
      debugPrint('response.body: ${response.body}');
      Map<String, dynamic> jsonData =
          response.body.isEmpty ? {} : json.decode(response.body);
      if (statusCode == 200) {
        return;
      } else if (statusCode == 400) {
        // debugPrint(jsonData.toString());
        throw ServerException(exceptionMessage: jsonData['error']);
      } else {
        throw ServerException(exceptionMessage: 'response status: $statusCode');
      }
    } catch (e) {
      throw ServerException(
        exceptionMessage: e.toString(),
      );
    }
  }
}
