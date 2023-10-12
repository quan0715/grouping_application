import 'dart:convert';

// import 'package:flutter/material.dart';
import 'package:grouping_project/model/workspace/editable_card_model.dart';
import 'package:http/http.dart' as http;
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
import 'package:grouping_project/model/repo/patch_enum.dart';

const String baseURL =
    "http://{ip}"; // TODO: we need to know the django website

class DatabaseService {
  final String _uid;
  final Map<String, String> headers = {"ContentType": "application/json"};

  DatabaseService({required String uid}) : _uid = uid;

  /// user or group get event
  Future<EventModel> _getEvent(String eventId) async {
    final response = await http
        .get(Uri.http("$baseURL/$_uid/activities/$eventId"), headers: headers);

    if (response.statusCode == 200) {
      return EventModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return EventModel.defaultEvent;
    }
  }

  /// user or group create event
  Future<EventModel> _createEvent() async {
    final response = await http
        .post(Uri.http("$baseURL/$_uid/activities/events"), headers: headers);

    // successfully set up new data
    if (response.statusCode == 201) {
      return EventModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return EventModel.defaultEvent;
    }
  }

  /// user or group get mission
  Future<MissionModel> _getMission(String missionId) async {
    final response = await http.get(
        Uri.http("$baseURL/$_uid/activities/$missionId"),
        headers: headers);

    if (response.statusCode == 200) {
      return MissionModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return MissionModel.defaultMission;
    }
  }

  /// user or group create mission
  Future<MissionModel> _createMission() async {
    final response = await http
        .post(Uri.http("$baseURL/$_uid/activities/missions"), headers: headers);

    // successfully set up new data
    if (response.statusCode == 201) {
      return MissionModel.fromJson(data: jsonDecode(response.body));
    } else {
      // TODO: raise Error
      return MissionModel.defaultMission;
    }
  }

  /// can only update 'title', 'description', 'startTime', 'endTime', 'deadline'
  void _updateData(String ActivityId, ActivityCategory category) async {
    final response = await http.patch(
        Uri.http("$baseURL/$_uid/activities/$ActivityId"),
        headers: headers,
        body: {category.name.toString(): category.data});

    if (response.statusCode == 200) {
      // do nothing
    } else {
      // TODO: raise Error
    }
  }

  /// user or group delete actvity
  void _deleteActivity(EditableCardModel activity) async {
    final response = await http.delete(
        Uri.parse("$baseURL/$_uid/activities/${activity.id}"),
        headers: headers);

    // successfully delete data
    if (response.statusCode == 204) {
      // do nothing
    } else {
      // TODO: raise Error
    }
  }

  /// append contributor of activity
  void _appendContributor(String newContributorId, String activityId) async {
    final response = await http.patch(
        Uri.parse(
            "$baseURL/$_uid/activities/$activityId/contributors/$newContributorId"),
        headers: headers,
        body: {"contributors": activityId});

    // successfully append a contributor
    if (response.statusCode == 200) {
      // do nothing
    } else {
      // TODO: raise Error
    }
  }

  /// append child mission of activity
  void _appendChildMission(String childMissionId, String activityId) async {
    final response = await http.patch(
        Uri.parse(
            "$baseURL/$_uid/activities/$activityId/child_mission/$childMissionId"),
        headers: headers,
        body: {"child_mission": childMissionId});

    // successfully append a contributor
    if (response.statusCode == 200) {
      // do nothing
    } else {
      // TODO: raise Error
    }
  }
}
