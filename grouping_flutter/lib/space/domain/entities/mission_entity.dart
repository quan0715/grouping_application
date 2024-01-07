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
      // creator: UserModel.fromEntity(creator),
      creator: creator.toModel(),
      createTime: createTime,
      // belongWorkspace: WorkspaceModel.fromEntity(belongWorkspace),
      belongWorkspace: belongWorkspace.toModel(),
      // contributors: contributors.map((contributor) => UserModel.fromEntity(contributor)).toList(),
      contributors: contributors.map((contributor) => contributor.toModel()).toList(),
      // parentMissionIDs: parentMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
      // childMissions: childMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
      childMissions: childMissions.map((mission) => mission.toModel()).toList(),
      notifications: notifications,
    );
  }

  // @override
  // factory MissionEntity.fromModel(MissionModel model) {
  //   return MissionEntity(
  //       id: model.id!,
  //       title: model.title,
  //       introduction: model.introduction,
  //       creator: UserEntity.fromModel(model.creator),
  //       createTime: model.createTime,
  //       belongWorkspace: WorkspaceEntity.fromModel(model.belongWorkspace),
  //       deadline: model.deadline,
  //       state: model.state,
  //       // parentMissionIDs: model.parentMissionIDs,
  //       childMissions: model.childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
  //       contributors: model.contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
  //       notifications: model.notifications,);
  // }
}
