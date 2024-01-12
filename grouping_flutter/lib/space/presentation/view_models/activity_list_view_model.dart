import 'package:flutter/material.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/models/mission_state_model.dart';
import 'package:grouping_project/space/data/models/mission_state_stage.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/provider/user_data_provider.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

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

  bool isCreateMode = false;
  bool isCreateEvent = false;

  int _missionTypePage = 0;
  DateTime _selectDate = DateTime.now();

  ActivityEntity? selectedActivity;

  WorkspaceModel tempGroup =
      WorkspaceModel(id: -1, name: "Grouping 專題研究小組", themeColor: 1, members: [
    Member(
      id: 1,
      userName: '張百寬',
      photo: ImageModel(
          imageId: -1,
          imageUri:
              "http://localhost:8000/media/images/55057ef5-65fd-4a36-bd09-1bf89fd4fa07.jpg",
          updateAt: DateTime.now()),
    ),
    Member(
      id: 2,
      userName: '許明瑞',
    ),
  ]);

  List<ActivityEntity> get tmpData => [
        EventEntity(
            id: 0,
            title: "code review",
            introduction: "this is a test when between duration",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace: tempGroup,
            startTime: DateTime.now(),
            endTime: DateTime.now().add(const Duration(hours: 1)),
            relatedMissionIds: []),
        MissionEntity(
            id: 1,
            title: "UI/UX 設計",
            introduction: "this is a test when before deadline",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace: tempGroup,
            deadline: DateTime.now().add(const Duration(hours: 1)),
            stateId: -1,
            state: MissionStateModel.defaultProgressState,
            parentMissionIds: [],
            childMissionIds: []),
        MissionEntity(
            id: 2,
            title: "Login issue 解決",
            introduction: "this is a test with passed deadline",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace: tempGroup,
            deadline: DateTime.now().subtract(const Duration(hours: 1)),
            stateId: -1,
            state: MissionStateModel.defaultPendingState,
            parentMissionIds: [],
            childMissionIds: []),
        EventEntity(
            id: 3,
            title: "進度報告會議",
            introduction: "this is a test before duration",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace:
                WorkspaceModel(id: -1, name: "軟工小組", themeColor: 2),
            startTime: DateTime.now().add(const Duration(days: 1)),
            endTime: DateTime.now().add(const Duration(days: 1, hours: 1)),
            relatedMissionIds: []),
        EventEntity(
            id: 4,
            title: "校運會練習",
            introduction: "this is a test after duration",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace:
                WorkspaceModel(id: -1, name: "test 的 workspace", themeColor: 4),
            startTime: DateTime.now().subtract(const Duration(hours: 1)),
            endTime: DateTime.now().subtract(const Duration(minutes: 1)),
            relatedMissionIds: []),
        MissionEntity(
            id: 5,
            title: "與教授的專題時間",
            introduction: "this is a test",
            contributors: [],
            notifications: [],
            creatorAccount: UserModel.defaultAccount,
            belongWorkspace:
                WorkspaceModel(id: -1, name: "test 的 workspace", themeColor: 4),
            deadline: DateTime.now().add(const Duration(hours: 1)),
            stateId: -1,
            state: MissionStateModel.defaultFinishState,
            parentMissionIds: [],
            childMissionIds: []),
      ];

  ActivityListViewModel({required this.userDataProvider});

  void selectActivity(ActivityEntity activity) {
    selectedActivity = activity;
    notifyListeners();
  }

  void init() {
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity() as ActivityEntity)
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
        .map((activity) => activity.toEntity() as ActivityEntity)
        .toList();
    activities = tmpData;
    // events = _sortEvents();
    // missions = _sortMissions();
  }

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

  setCreateMode(bool isCreateEvent) {
    isCreateMode = true;
    isCreateEvent = isCreateEvent;
    notifyListeners();
  }

  cancleCreateMode() {
    isCreateMode = false;
    isCreateEvent = false;
    notifyListeners();
  }
}

class ActivityData extends CalendarDataSource {
  ActivityData(List<ActivityEntity> source) {
    // appointments = source;
    // appointments = source.map((activity) => activity is MissionEntity ? activity.parentMissionIds.isEmpty : true).toList();
    appointments = source
        .where((activity) => activity is MissionEntity
            ? activity.parentMissionIds.isEmpty
            : true)
        .toList();
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

  bool isEditMode = false;

  DateTime startTimeInChange = DateTime.now();
  DateTime endTimeInChange = DateTime.now();
  String titleInChange = "";
  String introductionInChange = "";
  int missionStateIdInChange = -1;
  List<DateTime> notificationsInChange = [];
  List<String> relatedMissionIdsInChange = [];
  List<int> contributorsInChange = [];

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

  void init() {}

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

  void deleteActivity() {
    // TODO: delete activity from server
    // update user activity usecase here

    debugPrint("deleteActivity unimplemented!");

    notifyListeners();
  }

  void createMissionDone() {
    activityListViewModel!.isCreateMode = false;
    activityListViewModel!.isCreateEvent = false;
    // TODO: create mission to server
    // update user activity usecase here

    debugPrint("createMissionDone unimplemented!");

    notifyListeners();
  }

  void createEventDone() {
    // TODO: create event to server
    // update user activity usecase here

    debugPrint("createEventDone unimplemented!");
    activityListViewModel!.isCreateMode = false;
    activityListViewModel!.isCreateEvent = false;

    notifyListeners();
  }

  void intoEditMode() {
    isEditMode = true;

    startTimeInChange = startTimeDateTime;
    endTimeInChange = endTimeDateTime;
    titleInChange = selectedActivity.title;
    introductionInChange = selectedActivity.introduction;
    relatedMissionIdsInChange =
        isEvent ? (selectedActivity as EventEntity).relatedMissionIds : [];
    contributorsInChange = selectedActivity.contributors;
    missionStateIdInChange =
        isEvent ? -1 : (selectedActivity as MissionEntity).stateId;

    notifyListeners();
  }

  void editDone() {
    isEditMode = false;

    debugPrint(activityListViewModel!.selectedActivity!.toString());

    activityListViewModel!.selectedActivity = isEvent
        ? EventEntity(
            id: activityListViewModel!.selectedActivity!.id,
            title: titleInChange,
            introduction: introductionInChange,
            contributors: contributorsInChange,
            notifications: notificationsInChange,
            creatorAccount:
                activityListViewModel!.selectedActivity!.creatorAccount,
            belongWorkspace:
                activityListViewModel!.selectedActivity!.belongWorkspace,
            startTime: startTimeInChange,
            endTime: endTimeInChange,
            relatedMissionIds: relatedMissionIdsInChange)
        : MissionEntity(
            id: activityListViewModel!.selectedActivity!.id,
            title: titleInChange,
            introduction: introductionInChange,
            contributors: contributorsInChange,
            notifications: notificationsInChange,
            creatorAccount:
                activityListViewModel!.selectedActivity!.creatorAccount,
            belongWorkspace:
                activityListViewModel!.selectedActivity!.belongWorkspace,
            deadline: startTimeInChange,
            stateId: missionStateIdInChange,
            state: (activityListViewModel!.selectedActivity as MissionEntity)
                .state,
            parentMissionIds: relatedMissionIdsInChange,
            childMissionIds: []);

    debugPrint(activityListViewModel!.selectedActivity!.toString());

    notifyListeners();
  }

  void cancelEditOrCreate() {
    isEditMode = false;
    activityListViewModel!.cancleCreateMode();
    notifyListeners();
  }
}
