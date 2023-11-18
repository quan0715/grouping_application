import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:grouping_project/auth/data/models/sub_model.dart';
import 'package:grouping_project/auth/domain/entities/login_entity.dart';
import 'package:grouping_project/auth/domain/entities/register_entity.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/service/auth/auth_helpers.dart';
import 'package:http/http.dart' as http;

abstract class AuthRemoteDataSource{
  Future<AuthTokenModel> passwordLogin(LoginEntity loginEntity);
  Future<AuthTokenModel> register(RegisterEntity registerEntity);

}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource{
  @override
  Future<AuthTokenModel> passwordLogin(LoginEntity loginEntity) async{
    try {
      String endPoint = EndPointGetter.getAuthBackendEndpoint('signin');

      Map<String, String> body = {
        'account': loginEntity.email,
        'password': loginEntity.password,
      };
      final response = await http.post(Uri.parse(endPoint), body: body);

      int statusCode = response.statusCode;
      debugPrint('statusCode: $statusCode');
      // debugPrint(response.body);
      if(statusCode == 200){
        AuthTokenModel authTokenModel = AuthTokenModel.fromJson({
          'auth-token': response.body,
        });
        return authTokenModel;
      }else if (statusCode == 401){
        // debugPrint(jsonData.toString());
        Map<String, dynamic> jsonData = json.decode(response.body);
        throw ServerException(exceptionMessage: jsonData['error']);
      }else{
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
  Future<AuthTokenModel> register(RegisterEntity entity) async{
    try {
      String endPoint = EndPointGetter.getAuthBackendEndpoint('register');
      // FIX ME: use email or accountName?
      Map<String, String> body = {
        'account': entity.email,
        'password': entity.password,
        'username': entity.userName,
      };
      final response = await http.post(Uri.parse(endPoint), body: body);

      int statusCode = response.statusCode;
      debugPrint('statusCode: $statusCode');
      // debugPrint(response.body);
      if(statusCode == 200){
        AuthTokenModel authTokenModel = AuthTokenModel.fromJson({
          'auth-token': response.body,
        });
        return authTokenModel;
      }else if (statusCode == 401){
        // debugPrint(jsonData.toString());
        Map<String, dynamic> jsonData = json.decode(response.body);
        debugPrint(jsonData.toString());
        throw ServerException(exceptionMessage: jsonData['error']);
      }else{
        throw ServerException(exceptionMessage: 'response status: $statusCode');
      }
    } catch (e) {
      // debugPrint(e.toString());
      throw ServerException(
        exceptionMessage: e.toString(),
      );
    }
  }
}