import 'package:grouping_project/core/util/base_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/core/data/models/member_model.dart';
import 'package:grouping_project/space/data/models/event_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/domain/entities/workspace_entity.dart';

/// ## the type for [WorkspaceModel.tags]
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

class WorkspaceModel implements BaseModel<WorkspaceEntity>{
  final int id;
  int themeColor;
  String name;
  String description;
  ImageModel? photo;
  List<Member> members;
  List<ActivityModel> activities;
  List<WorkspaceTagModel> tags;

  WorkspaceModel({
    required this.id,
    required this.themeColor,
    required this.name,
    required this.description,
    required this.members,
    required this.activities,
    required this.tags,
    this.photo,
  });

  Map<String, dynamic> toJson() => <String, dynamic>{
        'theme_color': themeColor,
        'workspace_name': name,
        'description': description,
        'members': members.map((member) => member.id).toList(),
        'tags': tags.map((tag) => tag.toJson()).toList(),
      };

  /// I change the member cast to make it tempary correct,
  /// but it should be changed to the correct on later
  factory WorkspaceModel.fromJson({required Map<String, dynamic> data}) =>
      WorkspaceModel(
        id: data['id'] as int,
        themeColor: data['theme_color'] as int,
        name: data['workspace_name'] as String,
        description: data['description'] as String,
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
        members: (data['members'] as List)
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
        activities: (data['activities'].cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((activity) => activity['event'] != null
                ? EventModel.fromJson(data: activity)
                : MissionModel.fromJson(data: activity))
            .toList(),
        tags: (data['tags'].cast<Map<String, dynamic>>()
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
  
  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description);
}
