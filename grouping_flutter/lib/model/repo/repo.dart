import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';

const String baseURL = "http://ip"; // TODO: we need to know the django website

class DatabaseService {
  late final int _workSpaceUid;
  late final String _token;
  late final Map<String, String> headers;
  http.Client _client = http.Client();

  DatabaseService({required int workSpaceUid, required String token}) {
    _workSpaceUid = workSpaceUid;
    _token = token;
    headers = {
      "ContentType": "application/json",
      "Authorization": "Bearer $_token",
    };
  }

  void setClient(http.Client client) {
    _client = client;
  }

  http.Client getClient() {
    return _client;
  }

  /// user or group get event
  Future<EventModel> getEvent(int eventId) async {
    final response = await _client.get(
        Uri.parse("$baseURL/$_workSpaceUid/activities/$eventId"),
        headers: headers);

    if (response.statusCode == 200) {
      return EventModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return EventModel.defaultEvent;
    }
  }

  /// user or group create event
  Future<EventModel> createEvent(EventModel event) async {
    Map<String, dynamic> eventBody = event.toJson();
    eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.post(
        Uri.parse("$baseURL/$_workSpaceUid/activities"),
        headers: headers,
        body: jsonEncode(eventBody));

    // successfully set up new data
    if (response.statusCode == 201) {
      return EventModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else {
      // TODO: raise Error
      return EventModel.defaultEvent;
    }
  }

  Future<EventModel> updataEvent(EventModel event) async {
    Map<String, dynamic> eventBody = event.toJson();
    eventBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.patch(
        Uri.parse("$baseURL/$_workSpaceUid/activities/${event.id}"),
        headers: headers,
        body: jsonEncode(eventBody));

    // successfully set up new data
    if (response.statusCode == 200) {
      return EventModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return EventModel.defaultEvent;
    }
  }

  /// user or group get mission
  Future<MissionModel> getMission(int missionId) async {
    final response = await _client.get(
        Uri.parse("$baseURL/$_workSpaceUid/activities/$missionId"),
        headers: headers);

    if (response.statusCode == 200) {
      return MissionModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return MissionModel.defaultMission;
    }
  }

  /// user or group create mission
  Future<MissionModel> createMission(MissionModel mission) async {
    Map<String, dynamic> missionBody = mission.toJson();
    missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.post(
        Uri.parse("$baseURL/$_workSpaceUid/activities"),
        headers: headers,
        body: jsonEncode(missionBody));

    // successfully set up new data
    if (response.statusCode == 201) {
      return MissionModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else {
      // TODO: raise Error
      return MissionModel.defaultMission;
    }
  }

  Future<MissionModel> updataMission(MissionModel mission) async {
    Map<String, dynamic> missionBody = mission.toJson();
    missionBody.addAll({"belong_workspace": _workSpaceUid.toString()});

    final response = await _client.patch(
        Uri.parse("$baseURL/$_workSpaceUid/activities/${mission.id}"),
        headers: headers,
        body: jsonEncode(missionBody));

    // successfully set up new data
    if (response.statusCode == 200) {
      return MissionModel.fromJson(data: jsonDecode(response.body));
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      // TODO: raise Error
      return MissionModel.defaultMission;
    }
  }

  /// user or group delete actvity
  Future<void> deleteActivity(int activityId) async {
    final response = await _client.delete(
        Uri.parse("$baseURL/$_workSpaceUid/activities/$activityId"),
        headers: headers);

    // successfully delete data
    if (response.statusCode == 200) {
      // do nothing
    } else if (response.statusCode == 400) {
      throw Exception("Invalid Syntax");
    } else if (response.statusCode == 404) {
      throw Exception("The requesting data was not found");
    } else {
      throw Exception("Unknown error");
    }
  }
}
