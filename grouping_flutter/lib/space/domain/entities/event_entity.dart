import 'package:grouping_project/core/data/nested_activity.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
// import 'package:grouping_project/space/domain/entities/mission_entity.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';
// import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

class EventEntity extends ActivityEntity {
  DateTime startTime;
  DateTime endTime;

  EventEntity({
    required super.id,
    required super.title,
    required super.introduction,
    required super.creator,
    required super.createTime,
    required this.startTime,
    required this.endTime,
    required super.belongWorkspace,
    required super.childMissions,
    required super.contributors,
    required super.notifications,
  });

  @override
  EventModel toModel() {
    return EventModel(
      id: id,
      title: title,
      introduction: introduction,
      creator: creator,
      // creator: UserModel.fromEntity(creator),
      createTime: createTime,
      // belongWorkspace: WorkspaceModel.fromEntity(belongWorkspace),
      belongWorkspace: belongWorkspace,
      startTime: startTime,
      endTime: endTime,
      // childMissions: childMissions.map((mission) => MissionModel.fromEntity(mission)).toList(),
      childMissions: childMissions.map((mission) => mission.toModel()).toList(),
      // contributors: contributors.map((contributor) => UserModel.fromEntity(contributor)).toList(),
      // contributors:
      //     contributors.map((contributor) => contributor.toModel()).toList(),
      contributors: contributors,
      notifications: notifications,
    );
  }

  @override
  NestedEvent toNested() {
    return NestedEvent(
        id: id,
        title: title,
        startTime: startTime.toIso8601String(),
        endTime: endTime.toIso8601String(),
        belongWorkspace: belongWorkspace);
  }

  @override
  String toString() {
    return "id: $id\n, title: $title\n, introduction: $introduction\n, creator: $creator\n, createTime: $createTime\n, belong workspace: $belongWorkspace\n, startTime: $startTime\n, endTime: $endTime\n, child missions: $childMissions\n, contributor: $contributors\n, notification: $notifications\n";
  }
}
