// import 'dart:convert';

// import 'package:flutter_test/flutter_test.dart';
// import 'package:grouping_project/space/data/datasources/activity_repo.dart';
// import 'package:grouping_project/space/data/models/event_model.dart';
// import 'package:grouping_project/space/data/models/mission_model.dart';
// // import 'package:grouping_project/model/workspace/event_model.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:http/http.dart' as http;

// class MockClient extends Mock implements http.Client {}

// class FakeUri extends Fake implements Uri {}

/*
Future<void> testCreateEvent() async {
    CreateEventUseCase createEventUseCase = CreateEventUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    UpdateEventUseCase updateEventUseCase = UpdateEventUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    GetEventUseCase getEventUseCase = GetEventUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    DeleteActivityUseCase deleteActivityUseCase = DeleteActivityUseCase(
        ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    UserEntity user = userDataProvider.currentUser!;
    Member member = Member(id: user.id, userName: user.name);
    NestWorkspace workspace = NestWorkspace(
        id: 1,
        themeColor: 1,
        name: 'test 的個人空間',
        photo: null,);
    EventEntity defaultevent = EventEntity(
        id: 10,
        title: 'test title',
        introduction: 'test introduction',
        creator: member,
        createTime: DateTime.now(),
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        belongWorkspace: workspace,
        childMissions: [],
        contributors: [member],
        notifications: []);

    final failureOrEvent = await createEventUseCase.call(defaultevent);

    // MessageService messageService = userDataProvider.messageService!;
    failureOrEvent.fold((failure) {
      debugPrint('建立 event 失敗');
    }, (event) async {
      debugPrint("建立成功成功");
      debugPrint("\n========== start of create event ===========\n");
      debugPrint("$event");
      debugPrint("\n========== end of create event ===========\n");

      event.endTime = event.endTime.add(const Duration(days: 1));
      final failureOrUpdate = await updateEventUseCase.call(event);

      failureOrUpdate.fold((l) => debugPrint("更新失敗"), (updateEvent) {
        debugPrint("更新成功");
        debugPrint("\n========== start of update event ===========\n");
        debugPrint("\n$updateEvent\n");
        debugPrint("\n========== end of update event ===========\n");
      });

      final failureOrGet = await getEventUseCase.call(event.id);

      failureOrGet.fold((l) => debugPrint("獲取失敗"), (getEvent) {
        debugPrint("獲取成功");
        debugPrint("\n========== start of get event ===========\n");
        debugPrint("$getEvent");
        debugPrint("\n========== end of get event ===========\n");
      });

      debugPrint('成功創立，準備執行刪除');
      debugPrint(event.id.toString());
      final failiureOrSuccess = await deleteActivityUseCase.call(event.id);

      failiureOrSuccess.fold((l) => debugPrint('刪除 event 失敗'),
          (r) => debugPrint("========== 刪除成功 ==========="));
    });
  }

  Future<void> testState() async {
    CreateStateUsecase createStateUsecase = CreateStateUsecase(
        stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));
    
    UpdateStateUsecase updateStateUsecase = UpdateStateUsecase(stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));

    GetStateUsecase getStateUsecase = GetStateUsecase(stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));
    
    DeleteStateUsecase deleteStateUsecase = DeleteStateUsecase(stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));

    UserEntity user = userDataProvider.currentUser!;
    NestWorkspace workspace = NestWorkspace(
        id: 1,
        themeColor: 1,
        name: 'test 的個人空間',
        photo: null,);

    MissionState defaultstate = MissionState(id: -1, stage: MissionStage.close, stateName: 'test stateName', belongWorkspace: workspace);

    final failureOrState = await createStateUsecase.call(defaultstate);

    failureOrState.fold((l) => debugPrint("建立 mission state 失敗"), (state) async {
      debugPrint("建立成功成功");
      debugPrint("\n========== start of create state ===========\n");
      debugPrint("$state");
      debugPrint("\n========== end of create state ===========\n");

      state.stateName = 'update new stateName';
      final failureOrUpdate = await updateStateUsecase.call(state);

      failureOrUpdate.fold((l) => debugPrint("更新 mission state 失敗"), (updateState) async {
        debugPrint("更新成功");
        debugPrint("\n========== start of update state ===========\n");
        debugPrint("\n$updateState\n");
        debugPrint("\n========== end of update state ===========\n");
      });

      final failureOrGet = await getStateUsecase.call(state.id);

      failureOrGet.fold((l) => debugPrint("獲取 mission state 失敗"), (getState) async {
        debugPrint("獲取成功成功");
        debugPrint("\n========== start of get state ===========\n");
        debugPrint("\n$getState\n");
        debugPrint("\n========== end of get state ===========\n");
      });

      final failureOrDelete = await deleteStateUsecase.call(state.id);

      failureOrDelete.fold((l) => debugPrint("刪除 mission state 失敗"), (r) => debugPrint("刪除成功"));
    });
  }

  Future<void> testCreateMission() async {
    CreateStateUsecase createStateUsecase = CreateStateUsecase(
        stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));
    DeleteStateUsecase deleteStateUsecase = DeleteStateUsecase(stateRepository: StateRepositoryImpl(
            remoteDataSource: StateRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: StateLocalDataSourceImpl()));

    CreateMissionUseCase createMissionUseCase = CreateMissionUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    UpdateMissionUseCase updateMissionUseCase = UpdateMissionUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    GetMissionUseCase getMissionUseCase = GetMissionUseCase(
        activityRepository: ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    DeleteActivityUseCase deleteActivityUseCase = DeleteActivityUseCase(
        ActivityRepositoryImpl(
            remoteDataSource: ActivityRemoteDataSourceImpl(
                token: userDataProvider.tokenModel.token),
            localDataSource: ActivityLocalDataSourceImpl()));

    UserEntity user = userDataProvider.currentUser!;
    Member member = Member(id: user.id, userName: user.name);
    NestWorkspace workspace = NestWorkspace(
        id: 1,
        themeColor: 1,
        name: 'test 的個人空間',
        photo: null,);

    MissionState state = MissionState(id: -1, stage: MissionStage.progress, stateName: 'test stateName', belongWorkspace: workspace);
    (await createStateUsecase.call(state)).fold((l) => debugPrint("create state fail"), (r) => state = r);

    MissionEntity defaultmission = MissionEntity(
        id: 10,
        title: 'test title',
        introduction: 'test introduction',
        creator: member,
        createTime: DateTime.now(),
        state: state,
        deadline: DateTime.now().add(const Duration(hours: 1)),
        belongWorkspace: workspace,
        childMissions: [],
        contributors: [member],
        notifications: []);

    final failureOrMission = await createMissionUseCase.call(defaultmission);

    // MessageService messageService = userDataProvider.messageService!;
    failureOrMission.fold((failure) {
      debugPrint('建立 mission 失敗');
    }, (mission) async {
      debugPrint("建立成功成功");
      debugPrint("\n========== start of create mission ===========\n");
      debugPrint("$mission");
      debugPrint("\n========== end of create mission ===========\n");

      mission.deadline = mission.deadline.add(const Duration(days: 1));
      final failureOrUpdate = await updateMissionUseCase.call(mission);

      failureOrUpdate.fold((l) => debugPrint("更新失敗"), (updateMission) {
        debugPrint("更新成功");
        debugPrint("\n========== start of update mission ===========\n");
        debugPrint("\n$updateMission\n");
        debugPrint("expected: ${mission.deadline}, actual: ${updateMission.deadline}");
        debugPrint("\n========== end of update mission ===========\n");
      });

      final failureOrGet = await getMissionUseCase.call(mission.id);

      failureOrGet.fold((l) => debugPrint("獲取失敗"), (getMission) {
        debugPrint("獲取成功");
        debugPrint("\n========== start of get mission ===========\n");
        debugPrint("$getMission");
        debugPrint("\n========== end of get mission ===========\n");
      });

      debugPrint('成功創立，準備執行刪除');
      debugPrint(mission.id.toString());
      final failiureOrSuccess = await deleteActivityUseCase.call(mission.id);

      failiureOrSuccess.fold((l) => debugPrint('刪除 mission 失敗'),
          (r) => debugPrint("========== 刪除成功 ==========="));
      
      (await deleteStateUsecase.call(state.id)).fold((l) => debugPrint("delete state faile"), (r) => debugPrint("delete state success"));
    });
  }
  */

// void main() {
  /*
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
  */
// }
