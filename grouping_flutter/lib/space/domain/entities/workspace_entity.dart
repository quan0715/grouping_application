import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
// import 'package:grouping_project/space/domain/entities/user_entity.dart';


class WorkspaceEntity {
  final int id;
  int themeColor;
  String name;
  String description;
  final ImageModel? photo;
  // final List<int> memberIds;
  final List<Member> members;
  final List<ActivityModel> activities;
  List<WorkspaceTagModel> tags;

  WorkspaceEntity(
      {required this.id,
      required this.themeColor,
      required this.name,
      required this.description,
      required this.photo,
      required this.members,
      required this.activities,
      required this.tags});
  
  factory WorkspaceEntity.newWorkspace() {
    return WorkspaceEntity(
      id: -1,
      themeColor: 0,
      name: '',
      description: '',
      photo: null,
      members: [],
      activities: [],
      tags: [],
    );
  }

  @override
  String toString() {
    // TODO: implement toString
    return "WorkspaceEntity(id: $id, themeColor: $themeColor, name: $name, description: $description, photo: $photo, members: $members, activities: $activities, tags: $tags)";
  }
}
