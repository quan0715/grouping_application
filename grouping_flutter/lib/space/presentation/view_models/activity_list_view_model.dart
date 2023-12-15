import 'package:flutter/material.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
import 'package:grouping_project/space/domain/entities/event_entity.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/presentation/view_models/user_page_view_model.dart';

class ActivityListViewModel extends ChangeNotifier {
  UserDataProvider userDataProvider;
  List<ActivityEntity>? activities;
  int _missionTypePage = 0;

  ActivityListViewModel({required this.userDataProvider});

  void init() {
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity() as ActivityEntity)
        .toList();
  }

  void update(UserDataProvider userProvider) {
    // debugPrint("UserViewModel update userData");
    userDataProvider = userProvider;
    activities = userDataProvider.currentUser!.contributingActivities
        .map((activity) => activity.toEntity() as ActivityEntity)
        .toList();
  }

  int _compareDateTime(DateTime front, DateTime rear){
    int result = front.compareTo(rear);
    if(result == 0){
      return -1;
    } else {
      return result;
    }
  }

  List<EventEntity> get events {
    List<EventEntity> allEvents = activities!.whereType<EventEntity>().toList();
    allEvents.sort((front, rear) => _compareDateTime(front.startTime, rear.startTime));
    return allEvents;
  }

  List<MissionEntity> get missions {
    List<MissionEntity> allMissions = activities!.whereType<MissionEntity>().toList();
    allMissions.sort((front, rear) => _compareDateTime(front.deadline, rear.deadline));
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
