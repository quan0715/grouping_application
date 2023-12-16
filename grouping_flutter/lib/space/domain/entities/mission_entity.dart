import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';

class MissionEntity extends ActivityEntity{
  DateTime deadline;
  int stateId;
  MissionStateModel state;
  List<String> parentMissionIds;
  List<String> childMissionIds;

  MissionEntity(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.contributors,
      required super.notifications,
      required super.creatorAccount,
      required super.belongWorkspace,
      required this.deadline,
      required this.stateId,
      required this.state,
      required this.parentMissionIds,
      required this.childMissionIds,});
}
