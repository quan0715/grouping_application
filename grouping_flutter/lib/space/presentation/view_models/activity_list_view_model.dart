import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/data/models/mission_state_stage.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/theme/color.dart';
// import 'package:grouping_project/space/data/models/mission_state_stage.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

// will be deleted after test
// import 'package:grouping_project/core/data/models/image_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/domain/entities/workspace_entity.dart';
// import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
// import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
// import 'package:grouping_project/space/data/repositories/activity_repository_impl.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/create_event_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/get_event_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/update_event_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/create_mission_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/get_mission_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/update_mission_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/activity_usecases/delete_activity_usecase.dart';
// import 'package:grouping_project/space/data/datasources/local_data_source/state_local_data_source.dart';
// import 'package:grouping_project/space/data/datasources/remote_data_source/state_remote_data_source.dart';
// import 'package:grouping_project/space/data/repositories/state_repository_impl.dart';
// import 'package:grouping_project/space/domain/usecases/state_usecases/create_state_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/state_usecases/delete_state_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/state_usecases/get_state_usecase.dart';
// import 'package:grouping_project/space/domain/usecases/state_usecases/update_state_usecase.dart';

extension DateTimeExtension on DateTime {
  int get weekOfMonthStartFromMonday {
    var date = this;
    final firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    int sum = firstDayOfTheMonth.weekday - 1 + date.day;
    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }

  int get weekOfMonthStartFromSunday {
    var date = this;
    final firstDayOfTheMonth = DateTime(date.year, date.month, 1);
    int sum = firstDayOfTheMonth.weekday + date.day;
    if (sum % 7 == 0) {
      return sum ~/ 7;
    } else {
      return sum ~/ 7 + 1;
    }
  }
}

class ActivityListViewModel extends ChangeNotifier {
  UserDataProvider userDataProvider;
  List<ActivityEntity>? activities;
  List<EventEntity> get events => _sortEvents();
  List<MissionEntity> get missions => _sortMissions();

  int _missionTypePage = 0;
  DateTime _selectDate = DateTime.now();

  ActivityEntity? selectedActivity;

  NestWorkspace tempGroup = NestWorkspace(
    id: -1,
    name: "Grouping 專題研究小組",
    themeColor: 1,
    // members: [
    //   Member(
    //     id: 1,
    //     userName: '張百寬',
    //     photo: ImageModel(
    //         imageId: -1,
    //         imageUri:
    //             "http://localhost:8000/media/images/55057ef5-65fd-4a36-bd09-1bf89fd4fa07.jpg",
    //         updateAt: DateTime.now()),
    //   ),
    //   Member(
    //     id: 2,
    //     userName: '許明瑞',
    //   ),
    // ],
    // activities: [],
    // tags: [],
  );

  List<ActivityEntity> get tmpData { 
    UserEntity user = userDataProvider.currentUser!;
    Member member = Member(id: user.id, userName: user.name);
    return [
        EventEntity(
          id: 0,
          title: "code review",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: tempGroup,
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          childMissions: [],
        ),
        MissionEntity(
          id: 1,
          title: "UI/UX 設計",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: tempGroup,
          deadline: DateTime.now().add(const Duration(hours: 1)),
          // stateId: -1,
          state: MissionState(
              id: -1,
              stage: MissionStage.progress,
              stateName: "test progress",
              belongWorkspace: tempGroup),
          childMissions: [],
          // parentMissionIds: [],
          // childMissionIds: [],
        ),
        MissionEntity(
          id: 2,
          title: "Login issue 解決",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: tempGroup,
          deadline: DateTime.now().add(const Duration(hours: 1)),
          // stateId: -1,
          state: MissionState(
              id: -1,
              stage: MissionStage.progress,
              stateName: "test progress",
              belongWorkspace: tempGroup),
          childMissions: [],
          // parentMissionIds: [],
          // childMissionIds: [],
        ),
        EventEntity(
          id: 3,
          title: "進度報告會議",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: NestWorkspace(
              id: -1,
              name: "軟工小組",
              themeColor: 2,),
          startTime: DateTime.now().add(const Duration(days: 1)),
          endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
          childMissions: [],
          // relatedMissionIds: [],
        ),
        EventEntity(
          id: 4,
          title: "校運會練習",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: NestWorkspace(
              id: -1,
              name: "test 的 workspace",
              themeColor: 4,),
          startTime: DateTime.now(),
          endTime: DateTime.now().add(const Duration(hours: 1)),
          childMissions: [],
          // relatedMissionIds: [],
        ),
        MissionEntity(
          id: 5,
          title: "與教授的專題時間",
          introduction: "this is a test",
          contributors: [],
          notifications: [],
          // creatorAccount: UserModel.defaultAccount,
          creator: member,
          createTime: DateTime.now(),
          belongWorkspace: NestWorkspace(
              id: -1,
              name: "test 的 workspace",
              themeColor: 4,),
          deadline: DateTime.now().add(const Duration(hours: 1)),
          // stateId: -1,
          state: MissionState(
              id: -1,
              stage: MissionStage.close,
              stateName: "test finish",
              belongWorkspace: tempGroup),
          childMissions: [],
          // parentMissionIds: [],
          // childMissionIds: [],
        ),
      ];}

  ActivityListViewModel({required this.userDataProvider});

  void selectActivity(ActivityEntity activity) {
    selectedActivity = activity;
    notifyListeners();
  }

  void init() {
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity())
        .toList();
    activities = tmpData;
    selectedActivity = activities!.first;
    // events = _sortEvents();
    // missions = _sortMissions();
  }

  void update(UserDataProvider userProvider) {
    // debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity())
        .toList();
    activities = tmpData;
    // events = _sortEvents();
    // missions = _sortMissions();
  }

  List<MissionEntity> get todoMissions => missions
      .where((element) => element.state.stage == MissionStage.todo)
      .toList();
  List<MissionEntity> get v => missions
      .where((element) => element.state.stage == MissionStage.pending)
      .toList();
  List<MissionEntity> get progressingMissions => missions
      .where((element) => element.state.stage == MissionStage.progress)
      .toList();
  List<MissionEntity> get finishMissions => missions
      .where((element) => element.state.stage == MissionStage.close)
      .toList();

  int _compareDateTime(DateTime front, DateTime rear) {
    int result = front.compareTo(rear);
    if (result == 0) {
      return -1;
    } else {
      return result;
    }
  }

  bool _sameAsSelectedDay(DateTime date) {
    return date.year == _selectDate.year &&
        date.month == _selectDate.month &&
        date.day == _selectDate.day;
  }

  List<EventEntity> _sortEvents() {
    List<EventEntity> allEvents = activities!
        .whereType<EventEntity>()
        .where((event) =>
            _sameAsSelectedDay(event.startTime) ||
            _sameAsSelectedDay(event.endTime))
        .toList();
    allEvents.sort(
        (front, rear) => _compareDateTime(front.startTime, rear.startTime));
    return allEvents;
  }

  List<MissionEntity> _sortMissions() {
    List<MissionEntity> allMissions = activities!
        .whereType<MissionEntity>()
        .where((mission) => _sameAsSelectedDay(mission.deadline))
        .toList();
    allMissions
        .sort((front, rear) => _compareDateTime(front.deadline, rear.deadline));
    return allMissions;
  }

  void setMissionTypePage(int newTypePage) {
    _missionTypePage = newTypePage;
    notifyListeners();
  }

  get getMissionTypePage => _missionTypePage;

  void setSelectedDay(DateTime newDate) {
    _selectDate = newDate;
    // events = _sortEvents();
    // missions = _sortMissions();
    notifyListeners();
  }

  DateTime getSelectedDay() {
    return _selectDate;
  }

  DateTime setInitialDate() {
    DateTime initialDate = DateTime.now();
    switch (initialDate.weekOfMonthStartFromMonday % 4) {
      case 1:
        initialDate = initialDate;
        break;
      case 2:
        initialDate = initialDate.subtract(const Duration(days: 7));
        break;
      case 3:
        initialDate = initialDate.subtract(const Duration(days: 14));
        break;
      case 0:
        initialDate = initialDate.subtract(const Duration(days: 21));
        break;
    }
    return initialDate;
  }

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
}

class ActivityData extends CalendarDataSource {
  ActivityData(List<ActivityEntity> source) {
    appointments = source;
    // appointments = source.where((activity) => activity is MissionEntity ? activity.parentMissionIds.isEmpty : true).toList();
  }

  @override
  DateTime getStartTime(int index) {
    return (appointments![index] is EventEntity)
        ? appointments![index].startTime
        : appointments![index].deadline;
  }

  @override
  DateTime getEndTime(int index) {
    return (appointments![index] is EventEntity)
        ? appointments![index].endTime
        : appointments![index].deadline;
    // return appointments![index].to;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return AppColor.getWorkspaceColorByIndex(
        appointments![index].belongWorkspace.themeColor);
  }

  @override
  bool isAllDay(int index) {
    // return appointments![index].isAllDay;
    return false;
  }
}

class ActivityDisplayViewModel extends ChangeNotifier {
  // final
  ActivityListViewModel? activityListViewModel;

  ActivityEntity get selectedActivity =>
      activityListViewModel!.selectedActivity!;

  bool get isEventStartedNow =>
      (selectedActivity as EventEntity).startTime.compareTo(DateTime.now()) < 1;

  bool get isOverNow => isEvent
      ? (selectedActivity as EventEntity).endTime.compareTo(DateTime.now()) < 1
      : (selectedActivity as MissionEntity).deadline.compareTo(DateTime.now()) <
          1;

  Duration get timeDifference => isEvent
      ? (selectedActivity as EventEntity).startTime.difference(DateTime.now())
      : (selectedActivity as MissionEntity).deadline.difference(DateTime.now());

  Duration get endtimeDifference =>
      (selectedActivity as EventEntity).startTime.difference(DateTime.now());

  Color get activityColor => AppColor.getWorkspaceColorByIndex(
      selectedActivity.belongWorkspace.themeColor);

  ActivityDisplayViewModel({this.activityListViewModel});

  final formattedDate = DateFormat('MM 月 dd 日 HH:mm');

  bool get isEvent => selectedActivity is EventEntity;

  bool get isMission => selectedActivity is MissionEntity;

  String get startTime => formattedDate.format(isEvent
      ? (selectedActivity as EventEntity).startTime
      : (selectedActivity as MissionEntity).deadline);

  String get endTime => selectedActivity is EventEntity
      ? formattedDate.format((selectedActivity as EventEntity).endTime)
      : "null";

  update(ActivityListViewModel activityListViewModel) {
    // debugPrint("ActivityDisplayViewModel update");
    this.activityListViewModel = activityListViewModel;
    debugPrint(selectedActivity.toString());
    notifyListeners();
  }

  void init() {}

  set activityTitle(String newTitle) {
    selectedActivity.title = newTitle;
    activityListViewModel!.notifyListeners();
    notifyListeners();
  }
}
