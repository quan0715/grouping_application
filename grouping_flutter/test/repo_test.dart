import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/model/repo/repo.dart';
import 'package:grouping_project/model/workspace/event_model.dart';
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  group("repo test:", () {
    setUp(() {
      registerFallbackValue(FakeUri());
    });
    tearDown(() => null);

    test("get default data event model", () async {
      // Arrange
      final client = MockClient();
      EventModel event = EventModel.defaultEvent;

      Map<String, dynamic> object = event.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseEvent = jsonEncode(object);

      // final expectAnswer = jsonDecode(responseEvent);
      // debugPrint(expectAnswer['event'][]);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseEvent, 200));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.getEvent(0);

      // Assert
      expect(result, event);
    });

    test("get random data event model", () async {
      // Arrange
      final client = MockClient();
      EventModel event = EventModel(
          id: 0, title: 'test title', introduction: 'test introduction');
      // final encodeEvent = jsonEncode(event.toJson());

      Map<String, dynamic> object = event.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseEvent = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseEvent, 200));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.getEvent(0);

      // Assert
      expect(result, event);
    });

    test("get default data mission model", () async {
      // Arrange
      final client = MockClient();
      MissionModel mission = MissionModel.defaultMission;
      // final encodeMission = jsonEncode(mission.toJson());

      Map<String, dynamic> object = mission.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseMission = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseMission, 200));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.getMission("testMissionId");

      // Assert
      expect(result, mission);
    });

    test("get random data mission model", () async {
      // Arrange
      final client = MockClient();
      MissionModel mission = MissionModel(id: 0, title: 'test title', introduction: 'test introduction');
      // final encodeMission = jsonEncode(mission.toJson());

      Map<String, dynamic> object = mission.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseMission = jsonEncode(object);

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseMission, 200));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.getMission("testMissionId");

      // Assert
      expect(result, mission);
    });
  });
}
