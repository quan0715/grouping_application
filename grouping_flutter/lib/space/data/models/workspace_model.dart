
import 'package:grouping_project/space/data/models/image_model.dart';

/// ## the type for [WorkspaceModel.tags]
/// * [content] : the value for this tag
class WorkspaceTag {
  String content;
  WorkspaceTag({required this.content});

  @override
  String toString() {
    return 'WorkSpace tag: $content';
  }
}

class WorkspaceModel{
  final int? id;
  int themeColor;
  String name;
  String description;
  bool isPersonal;
  ImageModel? photo;
  List<String> memberIds;
  List<WorkspaceTag> tags;

  static final WorkspaceModel defaultWorkspace = WorkspaceModel._default();

  WorkspaceModel._default()
    : id = -1,
      name = 'unknown',
      description = 'unknown',
      themeColor = 0,
      isPersonal = true,
      photo = null,
      memberIds = [],
      tags = [];

  WorkspaceModel({
    int? id,
    int? themeColor,
    String? name,
    String? description,
    bool? isPersonal,
    ImageModel? photo,
    List<String>? memberIds,
    List<WorkspaceTag>? tags, 
  }) :  id = id ?? defaultWorkspace.id,
        themeColor = themeColor ?? defaultWorkspace.themeColor,
        name = name ?? defaultWorkspace.name,
        description = description ?? defaultWorkspace.description,
        isPersonal = isPersonal ?? defaultWorkspace.isPersonal,
        photo = photo ?? defaultWorkspace.photo,
        memberIds = memberIds ?? defaultWorkspace.memberIds,
        tags = tags ?? defaultWorkspace.tags;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'id': id,
    'theme_color': themeColor,
    'workspace_name': name,
    'description': description,
    'is_personal': isPersonal,
    'photo': photo?.toJson(),
    'members': memberIds,
    'tags': tags,
  };

  factory WorkspaceModel.fromJson({required Map<String, dynamic> data}) => WorkspaceModel(
    id: data['id'],
    themeColor: data['theme_color'],
    name: data['workspace_name'],
    description: data['description'],
    isPersonal: data['is_personal'],
    photo: data['photo'] != null ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>) : null,
    memberIds: data['members'].cast<String>() as List<String>,
    tags: data['tags'].cast<WorkspaceTag>() as List<WorkspaceTag>,
  );

  @override
  String toString() {
    return {
      "id": id,
      "themeColor": themeColor,
      "name": name,
      "description": description,
      "isPersonal": isPersonal,
      "photo": photo,
      "memberIds": memberIds,
      "tags": tags,
    }.toString();
  }
  
  @override
  bool operator ==(Object other) {
    return toString() == other.toString();
  }
  
  @override
  // TODO: implement hashCode
  int get hashCode => id!;
}