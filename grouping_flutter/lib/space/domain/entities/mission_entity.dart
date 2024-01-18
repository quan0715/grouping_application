import 'package:grouping_project/core/data/models/mission_state_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
// import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

class MissionEntity extends ActivityEntity {
  DateTime deadline;
  MissionState state;

  MissionEntity({
    required super.id,
    required super.title,
    required super.introduction,
    required super.creator,
    required super.createTime,
    required super.belongWorkspace,
    // required super.parentMissionIDs,
    required super.childMissions,
    required super.contributors,
    required super.notifications,
    required this.deadline,
    required this.state,
  });

  @override
  MissionModel toModel(){
    return MissionModel(
      id: id,
      title: title,
      introduction: introduction,
      deadline: deadline,
      state: state,
      creator: creator,
      createTime: createTime,
      belongWorkspace: belongWorkspace,
      contributors: contributors,
      // parentMissionIDs: parentMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
      childMissions: childMissions.map((mission) => mission.toModel()).toList(),
      notifications: notifications,
    );
  }

  @override
  String toString() {
    return "id: $id\n, title: $title\n, introduction: $introduction\n, creator: $creator\n, createTime: $createTime\n, belong workspace: $belongWorkspace\n, deadline: $deadline\n, state: {$state}\n, child missions: $childMissions\n, contributor: $contributors\n, notification: $notifications\n";
  }
}
