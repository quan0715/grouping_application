import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/util/base_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';

abstract class ActivityModel implements BaseModel<ActivityEntity>{
  final int id;
  String title;
  String introduction;
  Member creator;
  DateTime createTime;
  NestWorkspace belongWorkspace;
  // List<int> parentMissionIDs;
  List<MissionModel> childMissions;
  List<Member> contributors;
  List<DateTime> notifications;

  ActivityModel(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.creator,
      required this.createTime,
      required this.notifications,
      required this.belongWorkspace,
      // required this.parentMissionIDs,
      required this.childMissions});

  Map<String, dynamic> toJson();
}
