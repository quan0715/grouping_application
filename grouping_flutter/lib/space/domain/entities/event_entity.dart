import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
// import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
// import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

class EventEntity extends ActivityEntity<EventModel> {
  DateTime startTime;
  DateTime endTime;

  EventEntity(
      {required super.id,
      required super.title,
      required super.introduction,
      required super.creator,
      required super.createTime,
      required this.startTime,
      required this.endTime,
      required super.belongWorkspace,
      required super.childMissions,
      required super.contributors,
      required super.notifications,});

  @override
  EventModel toModel() {
    return EventModel(
      id: id,
      title: title,
      introduction: introduction,
      creator: creator.toModel(),
      // creator: UserModel.fromEntity(creator),
      createTime: createTime,
      // belongWorkspace: WorkspaceModel.fromEntity(belongWorkspace),
      belongWorkspace: belongWorkspace.toModel(),
      startTime: startTime,
      endTime: endTime,
      // childMissions: childMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
      childMissions: childMissions.map((mission) => mission.toModel()).toList(),
      // contributors: contributors.map((contributor) => UserModel.fromEntity(contributor)).toList(),
      contributors: contributors.map((contributor) => contributor.toModel()).toList(),
      notifications: notifications,
    );
  }

  // factory EventEntity.fromModel(EventModel model) {
  //   return EventEntity(
  //       id: model.id!,
  //       title: model.title,
  //       introduction: model.introduction,
  //       startTime: model.startTime,
  //       endTime: model.endTime,
  //       creator: UserEntity.fromModel(model.creator),
  //       createTime: model.createTime,
  //       belongWorkspace: WorkspaceEntity.fromModel(model.belongWorkspace),
  //       childMissions: model.childMissions.map((mission) => MissionEntity.fromModel(mission)).toList(),
  //       contributors: model.contributors.map((contributor) => UserEntity.fromModel(contributor)).toList(),
  //       notifications: model.notifications,);
  // }
}
