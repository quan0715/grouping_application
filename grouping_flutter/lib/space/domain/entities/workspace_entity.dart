import 'package:grouping_project/core/util/base_entity.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';


class WorkspaceEntity implements BaseEntity<WorkspaceModel>{
  final int id;
  int themeColor;
  String name;
  String description;
  final ImageModel? photo;
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

  @override
  WorkspaceModel toModel(){
    return WorkspaceModel(
      id: id,
      themeColor: themeColor,
      name: name,
      description: description,
      photo: photo,
      members: members,
      activities: activities,
      tags: tags,
    );
  }
  
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
    return "id: $id\n, themeColor: $themeColor\n, name: $name\n, description: $description\n, photo: $photo\n, members: $members\n, activities: $activities\n, tags: $tags\n";
  }
}
