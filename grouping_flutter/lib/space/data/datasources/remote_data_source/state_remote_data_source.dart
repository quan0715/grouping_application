import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:http/http.dart' as http;

abstract class StateRemoteDataSource {
  StateRemoteDataSource();
  Future<MissionState> getStateData({required int stateID});
  Future<MissionState> createStateData({required MissionState state});
  Future<MissionState> updateStateData({required MissionState state});
  Future<void> deleteStateData({required int stateID});
}

class StateRemoteDataSourceImpl extends StateRemoteDataSource{
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  StateRemoteDataSourceImpl({required String token}) {
    _token = token;
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  /// 設定當前 DatabaseService 要對後端傳遞的**客戶(client)** 
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 DatabaseService 要對後端傳遞的**客戶(client)**
  http.Client getClient() {
    return _client;
  }

  @override
  Future<MissionState> getStateData({required int stateID}) async {
    final response = await _client.get(Uri.parse("${Config.baseUriWeb}/api/states/$stateID/"), headers: headers);

    switch (response.statusCode) {
      case 200:
        try{
          return MissionState.fromJson(data: jsonDecode(response.body));
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error ${response.statusCode} when get state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        debugPrint("error ${response.statusCode} when get state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when get state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Unknown Error");
    }
  }

  @override
  Future<MissionState> createStateData({required MissionState state}) async {
    final response = await _client.post(Uri.parse("${Config.baseUriWeb}/api/states/"), headers: headers);

    switch (response.statusCode) {
      case 201:
        try{
          return MissionState.fromJson(data: jsonDecode(response.body));
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error ${response.statusCode} when create state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        debugPrint("error ${response.statusCode} when create state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Unknown Error");
    }
  }

  @override
  Future<MissionState> updateStateData({required MissionState state}) async {
    final response = await _client.patch(Uri.parse("${Config.baseUriWeb}/api/states/${state.id}"), headers: headers);

    switch (response.statusCode) {
      case 200:
        try{
          return MissionState.fromJson(data: jsonDecode(response.body));
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error ${response.statusCode} when update state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        debugPrint("error ${response.statusCode} when update state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when update state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Unknown Error");
    }
  }

  @override
  Future<void> deleteStateData({required int stateID}) async {
    final response = await _client.delete(Uri.parse("${Config.baseUriWeb}/api/states/$stateID/"), headers: headers);

    switch (response.statusCode) {
      case 200:
        return;
      case 400:
        debugPrint("error ${response.statusCode} when delete state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        debugPrint("error ${response.statusCode} when delete state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when delete state: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Unknown Error");
    }
  }
}