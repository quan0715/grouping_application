import 'package:grouping_project/core/util/data_mapper.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

/// ## the type for [WorkspaceModel.tags]
/// * [title] : the key for this tag
/// * [content] : the value for this tag
class WorkspaceTagModel {
  String content;
  WorkspaceTagModel({required this.content});

  factory WorkspaceTagModel.fromJson({required Map<String, dynamic> data}) =>
      WorkspaceTagModel(content: data['content'] ?? 'empty');

  Map<String, dynamic> toJson() => <String, dynamic>{
        'content': content,
      };

  @override
  String toString() {
    return 'content : $content';
  }
}

class WorkspaceModel extends DataMapper<WorkspaceEntity> {
  final int? id;
  int themeColor;
  String name;
  String description;
  ImageModel? photo;
  List<Member> members;
  List<ActivityModel> activities;
  List<WorkspaceTagModel> tags;

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
    List<WorkspaceTagModel>? tags,
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
         // 'photo_data': photo?.toJson(),
        'members': members.map((member) => member.id).toList(),
        'activities': activities.map((activity) => activity.toJson()).toList(),
        'tags': tags.map((tag) => tag.toJson()).toList(),
      };

  /// I change the member cast to make it tempary correct,
  /// but it should be changed to the correct on later
  factory WorkspaceModel.fromJson({required Map<String, dynamic> data}) =>
      WorkspaceModel(
        id: data['id'] ?? defaultWorkspace.id,
        themeColor: data['theme_color'] ?? defaultWorkspace.themeColor,
        name: data['workspace_name'] ?? defaultWorkspace.name,
        description: data['description'] ?? defaultWorkspace.description,
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
        members: ((data['members'] ?? []) as List)
            .map((member){
              if(member is int){
                return Member(id: member, userName: 'unknown');
              }
              else if(member is Map<String, dynamic>){
                return Member.fromJson(data: member);
              }
              else{
                return Member(id: -1, userName: 'unknown');
              }}).toList(),
        activities: ((data['activities'] ?? []).cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((activity) => activity['event'] != null
                ? EventModel.fromJson(data: activity)
                : MissionModel.fromJson(data: activity))
            .toList(),
        tags: ((data['tags'] ?? []).cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((tag) => WorkspaceTagModel.fromJson(data: tag))
            .toList(),
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
      id: id ?? -1,
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
