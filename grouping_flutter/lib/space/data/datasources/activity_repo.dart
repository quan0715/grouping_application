// import 'dart:convert';

// // import 'package:flutter/material.dart';
// import 'package:grouping_project/space/data/models/event_model.dart';
// import 'package:grouping_project/space/data/models/mission_model.dart';
// import 'package:http/http.dart' as http;

// /// The server backend IP of the database
// const String baseURL = "http://ip"; // TODO: we need to know the django website

// /// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
// /// 
// /// 此 service 可以 get, create, update, delete event 或 mission
// ///
// class ActivityDatabaseService {
//   late final int _workSpaceUid;
//   late final String _token;
//   late final Map<String, String> headers;
//   http.Client _client = http.Client();

//   /// ## 這個 DatabaseService 主要是負責處理 event, mission 的功能操作
//   /// 
//   /// 此 service 可以 get, create, update, delete event 或 mission
//   ///
//   /// * [workSpaceUid] : 當前所處的 workspace 的 uid
//   /// * [token] : 使用者的認證碼
//   /// 
//   /// ### Example
//   /// ```dart
//   /// DatabaseService service = DatabaseService(workSpaceUid: -1, token: userToken);
//   /// ```
//   ///
//   ActivityDatabaseService({required int workSpaceUid, required String token}) {
//     _workSpaceUid = workSpaceUid;
//     _token = token;
//     headers = {
//       "ContentType": "application/json",
//       "Authorization": "Bearer $_token",
//     };
//   }

//   /// 設定當前 DatabaseService 要對後端傳遞的**客戶(client)** 
//   void setClient(http.Client client) {
//     _client = client;
//   }

//   /// 獲取當前 DatabaseService 要對後端傳遞的**客戶(client)**
//   http.Client getClient() {
//     return _client;
//   }

//   /// ## 獲取想要的 event 的資訊
//   /// 
//   /// 傳入 [eventId] 來獲取 [EventModel]\
//   /// 若未出錯則回傳 [EventModel]\
//   /// 若 [eventId] 有格式錯誤則會丟出 [Exception]\
//   /// 若 [eventId] 所對應的 [EventModel] 不存在則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// EventModel event = await DatabaseService.getEvent(eventId: -1);
//   /// ```
//   /// 
//   Future<EventModel> getEvent({required int eventId}) async {
//     final response = await _client.get(
//         Uri.parse("$baseURL/$_workSpaceUid/activities/$eventId"),
//         headers: headers);

//     if (response.statusCode == 200) {
//       return EventModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else if (response.statusCode == 404) {
//       throw Exception("The requesting data was not found");
//     } else {
//       // TODO: raise Error
//       return EventModel.defaultEvent;
//     }
//   }

//   /// ## 創立一個 event
//   /// 
//   /// 傳入 [EventModel] 來建立一個 [EventModel]\
//   /// 若未出錯則回傳 [EventModel]\
//   /// 若 [event] 有格式錯誤則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// EventModel event = await DatabaseService.createEvent(event: createDataofEvent);
//   /// ```
//   /// 
//   Future<EventModel> createEvent({required EventModel event}) async {
//     Map<String, dynamic> eventBody = event.toJson();
//     eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

//     final response = await _client.post(
//         Uri.parse("$baseURL/$_workSpaceUid/activities"),
//         headers: headers,
//         body: jsonEncode(eventBody));

//     // successfully set up new data
//     if (response.statusCode == 201) {
//       return EventModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else {
//       // TODO: raise Error
//       return EventModel.defaultEvent;
//     }
//   }

//   /// ## 更新 event 的資訊
//   /// 
//   /// 傳入 [EventModel] 來更新資料\
//   /// 若未出錯則回傳更新後的 [EventModel]\
//   /// 若 [event] 有格式錯誤則會丟出 [Exception]\
//   /// 若 [event] 所對應的 [EventModel] 不存在則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// EventModel event = await DatabaseService.updateEvent(event: updateModelofEvent);
//   /// ```
//   /// 
//   Future<EventModel> updataEvent({required EventModel event}) async {
//     Map<String, dynamic> eventBody = event.toJson();
//     eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

//     final response = await _client.patch(
//         Uri.parse("$baseURL/$_workSpaceUid/activities/${event.id}"),
//         headers: headers,
//         body: jsonEncode(eventBody));

//     // successfully set up new data
//     if (response.statusCode == 200) {
//       return EventModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else if (response.statusCode == 404) {
//       throw Exception("The requesting data was not found");
//     } else {
//       // TODO: raise Error
//       return EventModel.defaultEvent;
//     }
//   }

//   /// ## 獲取想要的 mission 的資訊
//   /// 
//   /// 傳入 [missionId] 來獲取 [MissionModel]\
//   /// 若未出錯則回傳 [MissionModel]\
//   /// 若 [missionId] 有格式錯誤則會丟出 [Exception]\
//   /// 若 [missionId] 所對應的 [EventModel] 不存在則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// MissionModel mission = await DatabaseService.getMission(missionId: -1);
//   /// ```
//   /// 
//   Future<MissionModel> getMission({required int missionId}) async {
//     final response = await _client.get(
//         Uri.parse("$baseURL/$_workSpaceUid/activities/$missionId"),
//         headers: headers);

//     if (response.statusCode == 200) {
//       return MissionModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else if (response.statusCode == 404) {
//       throw Exception("The requesting data was not found");
//     } else {
//       // TODO: raise Error
//       return MissionModel.defaultMission;
//     }
//   }

//   /// ## 創立一個 mission
//   /// 
//   /// 傳入 [MissionModel] 來建立一個 [MissionModel]\
//   /// 若未出錯則回傳 [MissionModel]\
//   /// 若 [mission] 有格式錯誤則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// MissionModel mission = await DatabaseService.createMission(mission: createDataofMission);
//   /// ```
//   /// 
//   Future<MissionModel> createMission({required MissionModel mission}) async {
//     Map<String, dynamic> missionBody = mission.toJson();
//     missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

//     final response = await _client.post(
//         Uri.parse("$baseURL/$_workSpaceUid/activities"),
//         headers: headers,
//         body: jsonEncode(missionBody));

//     // successfully set up new data
//     if (response.statusCode == 201) {
//       return MissionModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else {
//       // TODO: raise Error
//       return MissionModel.defaultMission;
//     }
//   }

//   /// ## 更新 mission 的資訊
//   /// 
//   /// 傳入 [MissionModel] 來更新資料\
//   /// 若未出錯則回傳更新後的 [MissionModel]\
//   /// 若 [mission] 有格式錯誤則會丟出 [Exception]\
//   /// 若 [mission] 所對應的 [MissionModel] 不存在則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// MissionModel mission = await DatabaseService.updateMission(mission: updateModelofMission);
//   /// ```
//   /// 
//   Future<MissionModel> updateMission({required MissionModel mission}) async {
//     Map<String, dynamic> missionBody = mission.toJson();
//     missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

//     final response = await _client.patch(
//         Uri.parse("$baseURL/$_workSpaceUid/activities/${mission.id}"),
//         headers: headers,
//         body: jsonEncode(missionBody));

//     // successfully set up new data
//     if (response.statusCode == 200) {
//       return MissionModel.fromJson(data: jsonDecode(response.body));
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else if (response.statusCode == 404) {
//       throw Exception("The requesting data was not found");
//     } else {
//       // TODO: raise Error
//       return MissionModel.defaultMission;
//     }
//   }

//   /// ## 刪除 event 或 mission
//   /// 
//   /// 傳入 [activityId] 來刪除所對應的 [EventModel] 或 [MissionModel]\
//   /// 若未出錯則不回傳\
//   /// 若 [activityId] 有格式錯誤則會丟出 [Exception]\
//   /// 若 [activityId] 所對應的 [EventModel] 或 [MissionModel] 不存在則會丟出 [Exception]
//   /// 
//   /// ### Example
//   /// ```dart
//   /// await WorkspaceService.deleteActivity(activityId: -1);
//   /// ```
//   /// 
//   Future<void> deleteActivity({required int activityId}) async {
//     final response = await _client.delete(
//         Uri.parse("$baseURL/$_workSpaceUid/activities/$activityId"),
//         headers: headers);

//     // successfully delete data
//     if (response.statusCode == 200) {
//       // do nothing
//     } else if (response.statusCode == 400) {
//       throw Exception("Invalid Syntax");
//     } else if (response.statusCode == 404) {
//       throw Exception("The requesting data was not found");
//     } else {
//       throw Exception("Unknown error");
//     }
//   }
// }
