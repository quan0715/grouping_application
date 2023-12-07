import 'package:grouping_project/core/util/data_mapper.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

class WorkspaceModel extends DataMapper<WorkspaceEntity> {
  final int? id;
  int themeColor;
  String name;
  String description;
  ImageModel? photo;
  List<Member> members;
  List<ActivityModel> activities;
  List<String> tags;

  static final WorkspaceModel defaultWorkspace = WorkspaceModel._default();

  WorkspaceModel._default()
      : id = -1,
        name = 'unknown',
        description = 'unknown',
        themeColor = 0,
        photo = null,
        members = [],
        activities = [],
        tags = [];

  WorkspaceModel({
    int? id,
    int? themeColor,
    String? name,
    String? description,
    ImageModel? photo,
    List<Member>? members,
    List<ActivityModel>? activities,
    List<String>? tags,
  })  : id = id ?? defaultWorkspace.id,
        themeColor = themeColor ?? defaultWorkspace.themeColor,
        name = name ?? defaultWorkspace.name,
        description = description ?? defaultWorkspace.description,
        photo = photo ?? defaultWorkspace.photo,
        members = members ?? defaultWorkspace.members,
        activities = activities ?? defaultWorkspace.activities,
        tags = tags ?? defaultWorkspace.tags;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'theme_color': themeColor,
        'workspace_name': name,
        'description': description,
        'photo': photo?.toJson(),
        'members': members.map((member) => member.toJson()).toList(),
        'activities': activities.map((activity) => activity.toJson()).toList(),
        'tags': tags,
      };

  factory WorkspaceModel.fromJson({required Map<String, dynamic> data}) =>
      WorkspaceModel(
        id: data['id'] ?? defaultWorkspace.id,
        themeColor: data['theme_color'] ?? defaultWorkspace.themeColor,
        name: data['workspace_name'] ?? defaultWorkspace.name,
        description: data['description'] ?? defaultWorkspace.description,
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
        members: ((data['members'] ?? []).cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((member) => Member.fromJson(data: member))
            .toList(),
        activities: ((data['activities'] ?? [])
                .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>)
            .map((activity) => activity['event'] != null
                ? EventModel.fromJson(data: activity)
                : MissionModel.fromJson(data: activity))
            .toList(),
        tags: (data['tags'] ?? []).cast<String>() as List<String>,
      );

  @override
  String toString() {
    return {
      "id": id,
      "themeColor": themeColor,
      "name": name,
      "description": description,
      "photo": photo,
      "members": members,
      "activities": activities,
      "tags": tags,
    }.toString();
  }

  @override
  WorkspaceEntity toEntity() {
    return WorkspaceEntity(
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

  factory WorkspaceModel.fromEntity(WorkspaceEntity entity) {
    return WorkspaceModel(
      id: entity.id,
      themeColor: entity.themeColor,
      name: entity.name,
      description: entity.description,
      photo: entity.photo,
      members: entity.members,
      activities: entity.activities,
      tags: entity.tags,
    );
  }

  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
}
