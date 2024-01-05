import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:http/http.dart' as http;

abstract class ActivityRemoteDataSource {
  ActivityRemoteDataSource();
  Future<ActivityModel> getActivityData({required int activityID});
  Future<ActivityModel> createActivityData({required ActivityModel activity});
  Future<ActivityModel> updateActivityData({required ActivityModel activity});
  Future<void> deleteActivityData({required int activityID});
}

/// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
/// 
/// 此 service 可以 get, create, update, delete event 或 mission
///
class ActivityRemoteDataSourceImpl extends ActivityRemoteDataSource{
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
  /// 
  /// 此 service 可以 get, create, update, delete event 或 mission
  ///
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(token: uesrToken);
  /// ```
  ///
  ActivityRemoteDataSourceImpl({required String token}) {
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

  /// ## 獲取想要的 activity 的資訊
  /// 
  /// 傳入 [activityID] 來獲取 [ActivityModel]\
  /// 若未出錯則回傳 [ActivityModel]\
  /// 若 [activityID] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [activityID] 所對應的 [ActivityModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(token: uesrToken);
  /// EditableCardModel activity = await remoteDataSource.getActivityData(activityID: -1);
  /// ```
  /// 
  @override
  Future<ActivityModel> getActivityData({required int activityID}) async {
    final response = await _client.get(
        Uri.parse("${Config.baseUriWeb}/api/activities/$activityID/"),
        headers: headers);

    switch (response.statusCode) {
      case 200:
        try{
          var data = jsonDecode(response.body);
          return data['event'] != null ? EventModel.fromJson(data: data) : MissionModel.fromJson(data: data);
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error ${response.statusCode} when get activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        debugPrint("error ${response.statusCode} when get activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when get activity: \n${response.body}\n");
        // return EventModel.defaultEvent;
        throw ServerException(exceptionMessage: "Unknown Error");
    }
  }

  /// ## 創立一個 activity
  /// 
  /// 傳入 [ActivityModel] 來建立一個 [ActivityModel]\
  /// 若未出錯則回傳 [ActivityModel]\
  /// 若 [activity] 有格式錯誤則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(token: uesrToken);
  /// EditableCardModel activity = await remoteDataSource.createActivityData(activity: createDataofActivity);
  /// ```
  /// 
  @override
  Future<ActivityModel> createActivityData({required ActivityModel activity}) async {
    Map<String, dynamic> body = activity.toJson();
    // body.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.post(
        Uri.parse("${Config.baseUriWeb}/api/activities/"),
        headers: headers,
        body: jsonEncode(body));

    switch (response.statusCode) {
      case 201:
        try{
          var data = jsonDecode(response.body);
          return data['event'] != null ? EventModel.fromJson(data: data) : MissionModel.fromJson(data: data);
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error 400 when create activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        debugPrint("error ${response.statusCode} when create activity: \n${response.body}\n");
        // return EventModel.defaultEvent;
        throw ServerException(exceptionMessage: "unknown error");
    }
  }

  /// ## 更新 activity 的資訊
  /// 
  /// 傳入 [ActivityModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [ActivityModel]\
  /// 若 [activity] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [activity] 所對應的 [ActivityModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(token: uesrToken);
  /// EditableCardModel activity = await remoteDataSource.updateActivityData(event: updateDataofActivity);
  /// ```
  /// 
  @override
  Future<ActivityModel> updateActivityData({required ActivityModel activity}) async {
    Map<String, dynamic> body = activity.toJson();
    // body.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.patch(
        Uri.parse("${Config.baseUriWeb}/api/activities/${activity.id}/"),
        headers: headers,
        body: jsonEncode(body));

    switch (response.statusCode) {
      case 200:
        try{
          var data = jsonDecode(response.body);
          return data['event'] != null ? EventModel.fromJson(data: data) : MissionModel.fromJson(data: data);
        }
        catch (error) {
          debugPrint("database data error: $error");
          throw ServerException(exceptionMessage: "Database Data Error");
        }
      case 400:
        debugPrint("error ${response.statusCode} when update activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        debugPrint("error ${response.statusCode} when update activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when update activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "unknown error");
        // return EventModel.defaultEvent;
    }
  }

  /// ## 刪除 event 或 mission
  /// 
  /// 傳入 [activityID] 來刪除所對應的 [EventModel] 或 [MissionModel]\
  /// 若未出錯則不回傳\
  /// 若 [activityID] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [activityID] 所對應的 [EventModel] 或 [MissionModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(token: uesrToken);
  /// await remoteDataSource.deleteActivityData(activityID: -1);
  /// ```
  /// 
  @override
  Future<void> deleteActivityData({required int activityID}) async {
    final response = await _client.delete(
        Uri.parse("${Config.baseUriWeb}/api/activities/$activityID/"),
        headers: headers);

    switch (response.statusCode) {
      case 200:
        // do nothing
        return;
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        debugPrint("error ${response.statusCode} when get activity: \n${response.body}\n");
        throw ServerException(exceptionMessage: "unknown error");
        // do nothing
        // return;
    }
  }
}
