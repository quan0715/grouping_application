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

/// ## 這個 RemoteDataSource 主要是負責處理 [MissionState] 的功能操作
/// 
/// 此 service 可以 get, create, update, delete [MissionState]
///
class StateRemoteDataSourceImpl extends StateRemoteDataSource{
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 RemoteDataSource 主要是負責處理 [MissionState] 的功能操作
  /// 
  /// 此 service 可以 get, create, update, delete [MissionState]
  ///
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// StateRemoteDataSource remoteDataSource = StateRemoteDataSourceImpl(token: uesrToken);
  /// ```
  ///
  StateRemoteDataSourceImpl({required String token}) {
    _token = token;
    headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  /// 設定當前 RemoteDataSource 要對後端傳遞的**客戶(client)** 
  void setClient(http.Client client) {
    _client = client;
  }

  /// 獲取當前 RemoteDataSource 要對後端傳遞的**客戶(client)**
  http.Client getClient() {
    return _client;
  }

  /// ## 獲取想要的 [MissionState] 的資訊
  /// 
  /// 傳入 [stateID] 來獲取 [MissionState]\
  /// 若未出錯則回傳 [MissionState]\
  /// 若 [stateID] 有對應到 [MissionState] 但其內部存在非法 null field，則會丟出 [ServerException]\
  /// 若 [stateID] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [stateID] 所對應的 [MissionState] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// StateRemoteDataSource remoteDataSource = StateRemoteDataSourceImpl(token: uesrToken);
  /// MissionState state = await remoteDataSource.getStateData(stateID: -1);
  /// ```
  /// 
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

  /// ## 創立一個 [MissionState] 的資訊
  /// 
  /// 傳入想創立的 [MissionState] 的資料 [state]\
  /// 若未出錯則回傳 [MissionState]\
  /// 若 [state] 有對應到 [MissionState] 但其內部存在非法 null field，則會丟出 [ServerException]\
  /// 若 [state] 有格式錯誤則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// StateRemoteDataSource remoteDataSource = StateRemoteDataSourceImpl(token: uesrToken);
  /// MissionState state = await remoteDataSource.createStateData(state: someDataOfState);
  /// ```
  /// 
  @override
  Future<MissionState> createStateData({required MissionState state}) async {
    final response = await _client.post(Uri.parse("${Config.baseUriWeb}/api/states/"), headers: headers, body: jsonEncode(state.toJson()));

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

  /// ## 更新一個 [MissionState] 的資訊
  /// 
  /// 傳入想更新的 [MissionState] 的資料 [state]\
  /// 若未出錯則回傳 [MissionState]\
  /// 若 [state] 有對應到 [MissionState] 但其內部存在非法 null field，則會丟出 [ServerException]\
  /// 若 [state] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [state] 所對應的 [MissionState] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// StateRemoteDataSource remoteDataSource = StateRemoteDataSourceImpl(token: uesrToken);
  /// MissionState state = await remoteDataSource.updateStateData(state: someDataOfState);
  /// ```
  /// 
  @override
  Future<MissionState> updateStateData({required MissionState state}) async {
    final response = await _client.patch(Uri.parse("${Config.baseUriWeb}/api/states/${state.id}/"), headers: headers, body: jsonEncode(state.toJson()));

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

  /// ## 刪除一個 [MissionState] 的資訊
  /// 
  /// 傳入 [stateID] 來刪除對應的 [MissionState]\
  /// 若未出錯則不回傳\
  /// 若 [stateID] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [stateID] 所對應的 [MissionState] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// StateRemoteDataSource remoteDataSource = StateRemoteDataSourceImpl(token: uesrToken);
  /// await remoteDataSource.deleteStateData(stateID: -1);
  /// ```
  /// 
  @override
  Future<void> deleteStateData({required int stateID}) async {
    final response = await _client.delete(Uri.parse("${Config.baseUriWeb}/api/states/$stateID/"), headers: headers);

    switch (response.statusCode) {
      case 204:
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