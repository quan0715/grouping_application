import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:grouping_project/data/repo/activity_repo.dart';
// import 'package:grouping_project/model/workspace/event_model.dart';
import 'package:grouping_project/data/workspace/workspace_model_lib.dart';
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

      when(() => client.get(any(), headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response(responseEvent, 200));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.getEvent(eventId: -1);

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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.getEvent(eventId: -1);

      // Assert
      expect(result, event);
    });

    test("get event 的 id 不符合要求 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseEvent, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.getEvent(0);
      // fn() => database.getEvent(0);

      // Assert
      // expect(result, event);
      // expect(() async => await database.getEvent(0), throwsA(isA<Exception>()));
      expect(
          () async => await database.getEvent(eventId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("get event 的 event 不存在 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseEvent, 404));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.getEvent(0);
      // fn() => database.getEvent(0);

      // Assert
      // expect(result, event);
      // expect(() async => await database.getEvent(0), throwsA(isA<Exception>()));
      expect(
          () async => await database.getEvent(eventId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.createEvent(event: event);

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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.createEvent(event: event);

      // Assert
      expect(result, event);
    });

    test("create event 的 event 不符合格式 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseEvent, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.createEvent(event);

      // Assert
      expect(
          () async => await database.createEvent(event: event),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("藉由 update 獲得更新後的 event", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseEvent, 200));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.updataEvent(event: event);

      // Assert
      expect(result, event);
    });

    test("update event 的 event 不符合格式 (回傳 exception)", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseEvent, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.createEvent(event);

      // Assert
      expect(
          () async => await database.updataEvent(event: event),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("update event 的 event 不存在 (回傳 exception)", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseEvent, 404));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.createEvent(event);

      // Assert
      expect(
          () async => await database.updataEvent(event: event),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.getMission(missionId: -1);

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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.getMission(missionId: -1);

      // Assert
      expect(result, mission);
    });

    test("get mission 的 id 不符合要求 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseMission, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.getMission("testMissionId");

      // Assert
      // expect(result, mission);
      expect(
          () async => await database.getMission(missionId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("get mission 的 mission 不存在 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseMission, 404));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.getMission("testMissionId");

      // Assert
      // expect(result, mission);
      expect(
          () async => await database.getMission(missionId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.createMission(mission: mission);

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

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.createMission(mission: mission);

      // Assert
      expect(result, mission);
    });

    test("create mission 的 mission 不符合格式 (回傳 exception)", () async {
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
          .thenAnswer((_) async => http.Response(responseMission, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.createMission(mission);

      // Assert
      expect(
          () async => await database.createMission(mission: mission),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("藉由 update 獲得更新後的 mission", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseMission, 200));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      final result = await database.updateMission(mission: mission);

      // Assert
      expect(result, mission);
    });

    test("update mission 的 mission 不符合格式 (回傳 exception)", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseMission, 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.updataMission(mission);

      // Assert
      expect(
          () async => await database.updateMission(mission: mission),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("update mission 的 mission 不存在 (回傳 exception)", () async {
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

      when(() => client.patch(any(),
              headers: any(named: 'headers'), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response(responseMission, 404));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.updataMission(mission);

      // Assert
      expect(
          () async => await database.updateMission(mission: mission),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
    });
  });

  group("repo activity delete 測試:", () {
    setUp(() {
      registerFallbackValue(FakeUri());
    });
    tearDown(() => null);

    test("delete activity 是否正確", () async {
      // Arrange
      final client = MockClient();

      when(() => client.delete(any(),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 200));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.deleteActivity(0);

      // Assert
      expect(() async => await database.deleteActivity(activityId: -1), isA<void>());
    });

    test("delete activity 的 id 不符合格式 (回傳 exception)", () async {
      // Arrange
      final client = MockClient();

      when(() => client.delete(any(),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 400));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.deleteActivity(0);

      // Assert
      expect(
          () async => await database.deleteActivity(activityId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: Invalid Syntax")));
    });

    test("delete activity 的 id 不存在 (回傳 exception)", () async {
      // Arrange
      final client = MockClient();

      when(() => client.delete(any(),
              headers: any(named: 'headers')))
          .thenAnswer((_) async => http.Response('', 404));

      final database = ActivityDatabaseService(workSpaceUid: 0, token: "test");
      database.setClient(client);

      // Act
      // final result = await database.deleteActivity(0);

      // Assert
      expect(
          () async => await database.deleteActivity(activityId: -1),
          throwsA(predicate((e) =>
              e is Exception && e.toString() == "Exception: The requesting data was not found")));
    });
  });
}
