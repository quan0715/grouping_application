import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/model/repo/repo.dart';
import 'package:grouping_project/model/workspace/event_model.dart';
import 'package:grouping_project/model/workspace/workspace_model_lib.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

class FakeUri extends Fake implements Uri {}

void main() {
  group("repo event 功能測試:", () {
    setUp(() {
      registerFallbackValue(FakeUri());
    });
    tearDown(() => null);

    test("藉由 get 獲得預設的 event (default)", () async {
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

    test("藉由 get 獲得任意的 event", () async {
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

    test("藉由 create 獲得預設的 event (default)", () async {
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

      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseEvent, 201));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.createEvent(event);

      // Assert
      expect(result, event);
    });

    test("藉由 create 獲得任意的 event", () async {
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

      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseEvent, 201));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.createEvent(event);

      // Assert
      expect(result, event);
    });
  });

  group("repo mission 功能測試:", () {
    setUp(() {
      registerFallbackValue(FakeUri());
    });
    tearDown(() => null);

    
    test("藉由 get 獲得預設的 mission (default)", () async {
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

    test("藉由 get 獲得任意的 mission", () async {
      // Arrange
      final client = MockClient();
      MissionModel mission = MissionModel(
          id: 0, title: 'test title', introduction: 'test introduction');
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

    test("藉由 create 獲得預設的 mission (default)", () async {
      // Arrange
      final client = MockClient();
      MissionModel mission = MissionModel.defaultMission;
      // final encodeMission = jsonEncode(mission.toJson());

      Map<String, dynamic> object = mission.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseMission = jsonEncode(object);

      // final expectAnswer = jsonDecode(responseEvent);
      // debugPrint(expectAnswer['event'][]);

      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseMission, 201));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.createMission(mission);

      // Assert
      expect(result, mission);
    });

    test("藉由 create 獲得任意的 mission", () async {
      // Arrange
      final client = MockClient();
      MissionModel mission = MissionModel(
          id: 0, title: 'test title', introduction: 'test introduction');
      // final encodeMission = jsonEncode(mission.toJson());

      Map<String, dynamic> object = mission.toJson();
      object.addAll({
        "created_at": "2023-10-14T04:43:43.956571Z",
      });
      final responseMission = jsonEncode(object);

      when(() => client.post(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseMission, 201));

      final database = DatabaseService(workSpaceUid: 0);
      database.setClient(client);

      // Act
      final result = await database.createMission(mission);

      // Assert
      expect(result, mission);
    });
  });
}
