// import 'package:grouping_project/core/util/data_mapper.dart';
// import 'package:grouping_project/space/data/models/activity_model.dart';
// import 'package:grouping_project/space/data/models/user_model.dart';
// import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/util/base_entity.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/space/domain/entities/mission_entity.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

abstract class ActivityEntity implements BaseEntity<ActivityModel>{
  final int id;
  String title;
  String introduction;
  List<Member> contributors;
  List<DateTime> notifications;
  Member creator;
  DateTime createTime;
  NestWorkspace belongWorkspace;
  // late List<MissionEntity> parentMissions;
  List<MissionEntity> childMissions;



  ActivityEntity(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.creator,
      required this.createTime,
      required this.belongWorkspace,
      // required this.parentMissionIDs,
      required this.childMissions,
      required this.notifications,
      });
}
