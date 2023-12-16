import 'package:flutter/material.dart';
import 'package:grouping_project/space/data/models/mission_state_model.dart';
import 'package:grouping_project/space/data/models/mission_state_stage.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';

class ActivityListViewModel extends ChangeNotifier {
  UserDataProvider userDataProvider;
  List<ActivityEntity>? activities;
  List<EventEntity>? events;
  List<MissionEntity>? missions;
  int _missionTypePage = 0;


  List<ActivityEntity> tmpDatas = [
    EventEntity(
        id: -1,
        title: "code review",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace: WorkspaceModel(
            id: -1, name: "Grouping 專題研究小組", themeColor: 0xFF006874),
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        relatedMissionIds: []),
    MissionEntity(
        id: -1,
        title: "UI/UX 設計",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace: WorkspaceModel(
            id: -1, name: "Grouping 專題研究小組", themeColor: 0xFF006874),
        deadline: DateTime.now().add(const Duration(hours: 1)),
        stateId: -1,
        state: MissionStateModel.defaultProgressState,
        parentMissionIds: [],
        childMissionIds: []),
    MissionEntity(
        id: -1,
        title: "Login issue 解決",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace: WorkspaceModel(
            id: -1, name: "Grouping 專題研究小組", themeColor: 0xFF006874),
        deadline: DateTime.now().add(const Duration(hours: 1)),
        stateId: -1,
        state: MissionStateModel.defaultPendingState,
        parentMissionIds: [],
        childMissionIds: []),
    EventEntity(
        id: -1,
        title: "進度報告會議",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace:
            WorkspaceModel(id: -1, name: "軟工小組", themeColor: 0xFF206FCC),
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        relatedMissionIds: []),
    EventEntity(
        id: -1,
        title: "校運會練習",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace: WorkspaceModel(
            id: -1, name: "test 的 workspace", themeColor: 0xFFBF5F07),
        startTime: DateTime.now(),
        endTime: DateTime.now().add(const Duration(hours: 1)),
        relatedMissionIds: []),
    MissionEntity(
        id: -1,
        title: "與教授的專題時間",
        introduction: "this is a test",
        contributors: [],
        notifications: [],
        creatorAccount: UserModel.defaultAccount,
        belongWorkspace: WorkspaceModel(
            id: -1, name: "test 的 workspace", themeColor: 0xFFBF5F07),
        deadline: DateTime.now().add(const Duration(hours: 1)),
        stateId: -1,
        state: MissionStateModel.defaultFinishState,
        parentMissionIds: [],
        childMissionIds: []),
  ];

  ActivityListViewModel({required this.userDataProvider});

  void init() {
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity() as ActivityEntity)
        .toList();
    activities = tmpDatas;
    events = _sortEvents();
    missions = _sortMissions();
  }

  void update(UserDataProvider userProvider) {
    // debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity() as ActivityEntity)
        .toList();
    activities = tmpDatas;
    events = _sortEvents();
    missions = _sortMissions();
  }

  List<MissionEntity> get pengingMissions => missions!
      .where((element) => element.state.stage == MissionStage.pending)
      .toList();
  List<MissionEntity> get progressingMissions => missions!
      .where((element) => element.state.stage == MissionStage.progress)
      .toList();
  List<MissionEntity> get finishMissions => missions!
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

  List<EventEntity> _sortEvents() {
    List<EventEntity> allEvents = activities!.whereType<EventEntity>().toList();
    allEvents.sort(
        (front, rear) => _compareDateTime(front.startTime, rear.startTime));
    return allEvents;
  }

  List<MissionEntity> _sortMissions() {
    List<MissionEntity> allMissions =
        activities!.whereType<MissionEntity>().toList();
    allMissions
        .sort((front, rear) => _compareDateTime(front.deadline, rear.deadline));
    return allMissions;
  }

  void setMissionTypePage(int newTypePage) {
    _missionTypePage = newTypePage;
    notifyListeners();
  }

  int getMissionTypePage() {
    return _missionTypePage;
  }
}
