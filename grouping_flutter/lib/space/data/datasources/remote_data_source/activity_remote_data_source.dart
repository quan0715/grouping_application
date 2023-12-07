import 'dart:convert';

import 'package:grouping_project/core/config/config.dart';
import 'package:grouping_project/core/exceptions/exceptions.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:http/http.dart' as http;

abstract class ActivityRemoteDataSource {
  ActivityRemoteDataSource();
  Future<EventModel> getEventData({required int eventID});
  Future<EventModel> createEventData({required EventModel event});
  Future<EventModel> updateEventData({required EventModel event});
  Future<MissionModel> getMissionData({required int missionID});
  Future<MissionModel> createMissionData({required MissionModel mission});
  Future<MissionModel> updateMissionData({required MissionModel mission});
  // Future<EditableCardModel> getActivityData({required int activityID});
  // Future<EditableCardModel> createActivityData({required EditableCardModel editableCard});
  // Future<EditableCardModel> updateActivityData({required EditableCardModel editableCard});
  Future<void> deleteActivityData({required int activityID});
}

/// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
/// 
/// 此 service 可以 get, create, update, delete event 或 mission
///
class ActivityRemoteDataSourceImpl extends ActivityRemoteDataSource{
  late final int _workSpaceUid;
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  /// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
  /// 
  /// 此 service 可以 get, create, update, delete event 或 mission
  ///
  /// * [workSpaceUid] : 當前所處的 workspace 的 uid
  /// * [token] : 使用者的認證碼
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// ```
  ///
  ActivityRemoteDataSourceImpl({required int workSpaceUid, required String token}) {
    _workSpaceUid = workSpaceUid;
    _token = token;
    headers = {
      "ContentType": "application/json",
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

  /// ## 獲取想要的 event 的資訊
  /// 
  /// 傳入 [eventId] 來獲取 [EventModel]\
  /// 若未出錯則回傳 [EventModel]\
  /// 若 [eventId] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [eventId] 所對應的 [EventModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// EventModel event = await remoteDataSource.getEventData(eventID: -1);
  /// ```
  /// 
  @override
  Future<EventModel> getEventData({required int eventID}) async {
    final response = await _client.get(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities/$eventID"),
        headers: headers);
    
    switch (response.statusCode) {
      case 200:
        return EventModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        return EventModel.defaultEvent;
    }
  }

  /// ## 創立一個 event
  /// 
  /// 傳入 [EventModel] 來建立一個 [EventModel]\
  /// 若未出錯則回傳 [EventModel]\
  /// 若 [event] 有格式錯誤則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// EventModel event = await remoteDataSource.createEventData(event: createDataofEvent);
  /// ```
  /// 
  @override
  Future<EventModel> createEventData({required EventModel event}) async {
    Map<String, dynamic> eventBody = event.toJson();
    eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.post(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities"),
        headers: headers,
        body: jsonEncode(eventBody));

    switch (response.statusCode) {
      case 200:
        return EventModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        return EventModel.defaultEvent;
    }
  }

  /// ## 更新 event 的資訊
  /// 
  /// 傳入 [EventModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [EventModel]\
  /// 若 [event] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [event] 所對應的 [EventModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// EventModel event = await remoteDataSource.updateEventData(event: updateDataofEvent);
  /// ```
  /// 
  @override
  Future<EventModel> updateEventData({required EventModel event}) async {
    Map<String, dynamic> eventBody = event.toJson();
    eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.patch(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities/${event.id}"),
        headers: headers,
        body: jsonEncode(eventBody));

    switch (response.statusCode) {
      case 200:
        return EventModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        return EventModel.defaultEvent;
    }
  }

  /// ## 獲取想要的 mission 的資訊
  /// 
  /// 傳入 [missionId] 來獲取 [MissionModel]\
  /// 若未出錯則回傳 [MissionModel]\
  /// 若 [missionId] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [missionId] 所對應的 [MissionModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// MissionModel mission = await remoteDataSource.getMissionData(missionID: -1);
  /// ```
  /// 
  @override
  Future<MissionModel> getMissionData({required int missionID}) async {
    final response = await _client.get(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities/$missionID"),
        headers: headers);

    switch (response.statusCode) {
      case 200:
        return MissionModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        return MissionModel.defaultMission;
    }
  }

  /// ## 創立一個 mission
  /// 
  /// 傳入 [MissionModel] 來建立一個 [MissionModel]\
  /// 若未出錯則回傳 [MissionModel]\
  /// 若 [mission] 有格式錯誤則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// MissionModel mission = await remoteDataSource.createMissionData(missionID: createDataofMissino);
  /// ```
  /// 
  @override
  Future<MissionModel> createMissionData({required MissionModel mission}) async {
    Map<String, dynamic> missionBody = mission.toJson();
    missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.post(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities"),
        headers: headers,
        body: jsonEncode(missionBody));

    switch (response.statusCode) {
      case 200:
        return MissionModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      default:
        return MissionModel.defaultMission;
    }
  }

  /// ## 更新 mission 的資訊
  /// 
  /// 傳入 [MissionModel] 來更新資料\
  /// 若未出錯則回傳更新後的 [MissionModel]\
  /// 若 [mission] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [mission] 所對應的 [MissionModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// MissionModel mission = await remoteDataSource.updateMissionData(missionID: updateDataofMission);
  /// ```
  /// 
  @override
  Future<MissionModel> updateMissionData({required MissionModel mission}) async {
    Map<String, dynamic> missionBody = mission.toJson();
    missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.patch(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities/${mission.id}"),
        headers: headers,
        body: jsonEncode(missionBody));

    switch (response.statusCode) {
      case 200:
        return MissionModel.fromJson(data: jsonDecode(response.body));
      case 400:
        throw ServerException(exceptionMessage: "Invalid Syntax");
      case 404:
        throw ServerException(exceptionMessage: "The requesting data was not found");
      default:
        return MissionModel.defaultMission;
    }
  }

  /// ## 刪除 event 或 mission
  /// 
  /// 傳入 [activityId] 來刪除所對應的 [EventModel] 或 [MissionModel]\
  /// 若未出錯則不回傳\
  /// 若 [activityId] 有格式錯誤則會丟出 [ServerException]\
  /// 若 [activityId] 所對應的 [EventModel] 或 [MissionModel] 不存在則會丟出 [ServerException]
  /// 
  /// ### Example
  /// ```dart
  /// ActivityRemoteDataSource remoteDataSource = ActivityRemoteDataSourceImpl(workSpaceUid: -1, token: uesrToken);
  /// await remoteDataSource.deleteActivityData(activityID: -1);
  /// ```
  /// 
  @override
  Future<void> deleteActivityData({required int activityID}) async {
    final response = await _client.delete(
        Uri.parse("${Config.baseUriWeb}/$_workSpaceUid/activities/$activityID"),
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
        // do nothing
        return;
    }
  }
}
