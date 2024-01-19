import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/core/data/models/mission_state_stage.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/activity_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/local_data_source/workspace_local_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/activity_remote_data_source.dart';
import 'package:grouping_project/space/data/datasources/remote_data_source/workspace_remote_data_source.dart';
import 'package:grouping_project/space/data/repositories/activity_repository_impl.dart';
import 'package:grouping_project/space/data/repositories/workspace_repository_impl.dart';
// import 'package:grouping_project/space/data/models/mission_state_stage.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/usecases/activity_usecases/activity_usecase_lib.dart';
import 'package:grouping_project/space/domain/usecases/workspace_usecases/workspace_usecaes_lib.dart';
import 'package:grouping_project/space/presentation/provider/group_data_provider.dart';
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
  GroupDataProvider? workspaceDataProvider;

  List<ActivityEntity>? activities;
  List<EventEntity> get events => _sortEvents();
  List<MissionEntity> get missions => _sortMissions();

  bool isCreateMode = false;
  bool isCreateEvent = false;
  bool inChangeSwitchLock = false;
  bool isLoading = false;

  int _missionTypePage = 0;
  DateTime _selectDate = DateTime.now();

  ActivityEntity? selectedActivity;
  ActivityEntity? lastSelected;
  ActivityEntity emptyActivity = MissionEntity(
      id: -1,
      title: "",
      introduction: "",
      contributors: [],
      notifications: [],
      creator: Member(id: -1, userName: ""),
      createTime: DateTime.now(),
      belongWorkspace: NestWorkspace(
        id: -1,
        name: "empty",
        themeColor: 4,
      ),
      deadline: DateTime.now(),
      state: MissionState(id: -1, stage: MissionStage.todo, stateName: ""),
      childMissions: []);

  ActivityListViewModel(
      {required this.userDataProvider, this.workspaceDataProvider});

  void selectActivity(ActivityEntity activity) {
    selectedActivity = activity;
    notifyListeners();
  }

  void init() {
    activities = (workspaceDataProvider != null
            ? workspaceDataProvider!.currentWorkspace!.activities
            : userDataProvider.currentUser!.contributingActivities)
        .map((activity) => activity.toEntity())
        .toList();

    // activities = tmpData;
    selectedActivity =
        activities!.isNotEmpty ? activities!.first : emptyActivity;
    isLoading = false;
    // events = _sortEvents();
    // missions = _sortMissions();
  }

  void updateUser(UserDataProvider userProvider) {
    // debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity())
        .toList();
    // activities = tmpData;
    // events = _sortEvents();
    // missions = _sortMissions();
  }

  void updateWorkspace(GroupDataProvider groupProvider) {
    workspaceDataProvider = groupProvider;
    activities = workspaceDataProvider!.currentWorkspace!.activities
        .map((activity) => activity.toEntity())
        .toList();
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

  setCreateMode(bool isCreatingEvent) {
    isCreateMode = true;
    isCreateEvent = isCreatingEvent;
    inChangeSwitchLock = true;
    lastSelected = selectedActivity;

    notifyListeners();
  }

  cancleCreateMode() {
    isCreateMode = false;
    isCreateEvent = false;
    inChangeSwitchLock = false;
    selectedActivity = lastSelected;

    notifyListeners();
  }
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
  late ActivityRepositoryImpl _activityRepository;

  bool isEditMode = false;

  DateTime startTimeInChange = DateTime.now();
  DateTime endTimeInChange = DateTime.now();
  String titleInChange = "";
  String introductionInChange = "";
  // int missionStateIdInChange = -1;
  List<DateTime> notificationsInChange = [];
  List<MissionEntity> childMissionInChange = [];
  List<Member> contributorsInChange = [];

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

  Color get activityColor =>
      activityListViewModel!.workspaceDataProvider?.color ??
      AppColor.getWorkspaceColorByIndex(
          selectedActivity.belongWorkspace.themeColor);

  ActivityDisplayViewModel({this.activityListViewModel});

  final formattedDate = DateFormat('MM 月 dd 日 HH:mm');

  bool get isEvent => selectedActivity is EventEntity;

  bool get isMission => selectedActivity is MissionEntity;

  String get startTime => formattedDate.format(isEvent
      ? (selectedActivity as EventEntity).startTime
      : (selectedActivity as MissionEntity).deadline);

  DateTime get startTimeDateTime => isEvent
      ? (selectedActivity as EventEntity).startTime
      : (selectedActivity as MissionEntity).deadline;

  String get endTime => selectedActivity is EventEntity
      ? formattedDate.format((selectedActivity as EventEntity).endTime)
      : "null";

  DateTime get endTimeDateTime => selectedActivity is EventEntity
      ? (selectedActivity as EventEntity).endTime
      : DateTime.now();

  update(ActivityListViewModel activityListViewModel) {
    // debugPrint("ActivityDisplayViewModel update");
    this.activityListViewModel = activityListViewModel;
    debugPrint(selectedActivity.toString());
    notifyListeners();
  }

  void init() {
    _activityRepository = ActivityRepositoryImpl(
        remoteDataSource: ActivityRemoteDataSourceImpl(
            token: activityListViewModel!.userDataProvider.tokenModel.token),
        localDataSource: ActivityLocalDataSourceImpl());
  }

  set activityTitle(String newTitle) {
    selectedActivity.title = newTitle;
    activityListViewModel!.notifyListeners();
    notifyListeners();
  }

  setStartTimeInChange(DateTime newStartTime) {
    startTimeInChange = newStartTime;
    notifyListeners();
  }

  setEndTimeInChange(DateTime newEndTime) {
    endTimeInChange = newEndTime;
    notifyListeners();
  }

  get workspaceMembers => GetWorkspaceUseCase(WorkspaceRepositoryImpl(
          remoteDataSource: WorkspaceRemoteDataSourceImpl(
              token: activityListViewModel!.userDataProvider.tokenModel.token),
          localDataSource: WorkspaceLocalDataSourceImpl()))
      .call(activityListViewModel!.workspaceDataProvider!.workspaceIndex);

  void deleteActivity() {
    DeleteActivityUseCase(_activityRepository).call(selectedActivity.id);

    activityListViewModel!.notifyListeners();
    notifyListeners();
  }

  addContributer(Member member) {
    contributorsInChange.add(member);
    notifyListeners();
  }

  removeContributer(int id) {
    contributorsInChange.remove(id);
    notifyListeners();
  }

  void intoCreateMode({required bool isCreateEvent}) {
    activityListViewModel!.isCreateMode = true;
    activityListViewModel!.isCreateEvent = isCreateEvent;
    activityListViewModel!.inChangeSwitchLock = true;

    activityListViewModel!.lastSelected =
        activityListViewModel!.selectedActivity;

    activityListViewModel!.lastSelected =
        activityListViewModel!.selectedActivity;

    activityListViewModel!.selectedActivity =
        activityListViewModel!.emptyActivity;

    startTimeInChange = DateTime.now();
    endTimeInChange = DateTime.now().add(const Duration(hours: 1));
    titleInChange = "";
    introductionInChange = "";
    childMissionInChange = [];
    contributorsInChange = [];

    activityListViewModel!.notifyListeners();
    notifyListeners();
  }

  Future<void> createDone() async {
    // ActivityEntity activityEntity = activityListViewModel!.isCreateEvent
    //     ? EventEntity(
    if (activityListViewModel!.isCreateEvent) {
      CreateEventUseCase(activityRepository: _activityRepository).call(
          EventEntity(
              id: -1,
              title: titleInChange,
              introduction: introductionInChange,
              contributors: contributorsInChange,
              notifications: notificationsInChange,
              creator:
                  Member(
                      id: activityListViewModel!
                          .userDataProvider.currentUser!.id,
                      userName: activityListViewModel!
                          .userDataProvider.currentUser!.name),
              createTime: DateTime.now(),
              belongWorkspace: NestWorkspace(
                  id: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.id,
                  themeColor: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.themeColor,
                  name: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.name),
              startTime: startTimeInChange,
              endTime: endTimeInChange,
              childMissions: childMissionInChange));
    } else {
      CreateMissionUseCase(activityRepository: _activityRepository).call(
          MissionEntity(
              id: -1,
              title: titleInChange,
              introduction: introductionInChange,
              contributors: contributorsInChange,
              notifications: notificationsInChange,
              creator:
                  Member(
                      id: activityListViewModel!
                          .userDataProvider.currentUser!.id,
                      userName: activityListViewModel!
                          .userDataProvider.currentUser!.name),
              createTime: DateTime.now(),
              belongWorkspace: NestWorkspace(
                  id: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.id,
                  themeColor: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.themeColor,
                  name: activityListViewModel!
                      .workspaceDataProvider!.currentWorkspace!.name),
              deadline: startTimeInChange,
              state: (activityListViewModel!.selectedActivity as MissionEntity)
                  .state,
              childMissions: childMissionInChange));
    }

    // activityListViewModel!.activities!.add(activityEntity);
    // activityListViewModel!.selectedActivity = activityEntity;

    activityListViewModel!.isCreateMode = false;
    activityListViewModel!.isCreateEvent = false;
    activityListViewModel!.inChangeSwitchLock = false;

    await activityListViewModel!.workspaceDataProvider!.getWorkspace();

    notifyListeners();
  }

  void intoEditMode() {
    activityListViewModel!.lastSelected =
        activityListViewModel!.selectedActivity;
    activityListViewModel!.inChangeSwitchLock = true;
    isEditMode = true;

    startTimeInChange = startTimeDateTime;
    endTimeInChange = endTimeDateTime;
    titleInChange = selectedActivity.title;
    introductionInChange = selectedActivity.introduction;
    childMissionInChange =
        isEvent ? (selectedActivity as EventEntity).childMissions : [];
    contributorsInChange = selectedActivity.contributors;

    notifyListeners();
  }

  void editDone() {
    isEditMode = false;
    activityListViewModel!.inChangeSwitchLock = false;

    if (isEvent) {
      UpdateEventUseCase(activityRepository: _activityRepository).call(
          EventEntity(
              id: activityListViewModel!.selectedActivity!.id,
              title: titleInChange,
              introduction: introductionInChange,
              contributors: contributorsInChange,
              notifications: notificationsInChange,
              creator: activityListViewModel!.selectedActivity!.creator,
              createTime: activityListViewModel!.selectedActivity!.createTime,
              belongWorkspace:
                  activityListViewModel!.selectedActivity!.belongWorkspace,
              startTime: startTimeInChange,
              endTime: endTimeInChange,
              childMissions: childMissionInChange));
    } else {
      UpdateMissionUseCase(activityRepository: _activityRepository).call(
          MissionEntity(
              id: activityListViewModel!.selectedActivity!.id,
              title: titleInChange,
              introduction: introductionInChange,
              contributors: contributorsInChange,
              notifications: notificationsInChange,
              creator: activityListViewModel!.selectedActivity!.creator,
              createTime: activityListViewModel!.selectedActivity!.createTime,
              belongWorkspace:
                  activityListViewModel!.selectedActivity!.belongWorkspace,
              deadline: startTimeInChange,
              state: (activityListViewModel!.selectedActivity as MissionEntity)
                  .state,
              childMissions: childMissionInChange));

      notifyListeners();
    }
  }

  void cancelEditOrCreate() {
    isEditMode = false;
    activityListViewModel!.cancleCreateMode();
    activityListViewModel!.selectedActivity =
        activityListViewModel!.lastSelected;

    activityListViewModel!.notifyListeners();
    notifyListeners();
  }
}
