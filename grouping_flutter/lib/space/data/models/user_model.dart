import 'package:grouping_project/core/data/models/simple_activity.dart';
import 'package:grouping_project/core/data/models/simple_event.dart';
import 'package:grouping_project/core/data/models/simple_mission.dart';
import 'package:grouping_project/core/data/models/simple_workspace.dart';
import 'package:grouping_project/core/util/base_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';

// import '../workspace/data_model.dart';

/// ## the type for [UserModel.tags]
/// * [title] : the key for this tag
/// * [content] : the value for this tag
class UserTagModel {
  String title;
  String content;
  UserTagModel({required this.title, required this.content});

  factory UserTagModel.fromJson({required Map<String, dynamic> data}) =>
      UserTagModel(title: data['title'], content: data['content']);

  Map<String, dynamic> toJson() => <String, dynamic>{
        'title': this.title,
        'content': this.content,
      };

  @override
  String toString() {
    return 'title: $title, content: $content';
  }
}

/// ## a data model for account, either user or group
/// * ***DO NOT*** pass or set id for AccountModel
/// * to upload/download, use `DataController`
class UserModel implements BaseModel<UserEntity>{
  final int id;
  String account;
  String userName;
  String introduction;
  ImageModel? photo;
  List<UserTagModel> tags;
  List<SimpleWorkspace> joinedWorkspaces;
  List<SimpleActivity> contributingActivities;

  /// ## a data model for account, either user or group
  /// * ***DO NOT*** pass or set id for AccountModel
  /// * to upload/download, use `DataController`
  UserModel({
    required this.id,
    required this.account,
    required this.userName,
    required this.introduction,
    required this.tags,
    required this.joinedWorkspaces,
    required this.contributingActivities,
    this.photo,
  });

 
  Map<String, dynamic> toJson() => <String, dynamic>{
        'account': this.account,
        'user_name': this.userName,
        'introduction': this.introduction,
        'tags': this.tags.map((tag) => tag.toJson()).toList(),
      };

  factory UserModel.fromJson({required Map<String, dynamic> data}) => UserModel(
        id: data['id'],
        account: data['account'] as String,
        userName: data['user_name'] as String,
        introduction: data['introduction'] as String,
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
        tags: (data['tags'].cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((tag) => UserTagModel.fromJson(data: tag))
            .toList(),
        joinedWorkspaces: (data['joined_workspaces']
                .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>)
            .map((workspace) => SimpleWorkspace.fromJson(data: workspace))
            .toList(),
        contributingActivities: (data['contributing_activities']
                .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>)
            .map((activity) => activity['event'] != null
                ? SimpleEvent.fromJson(data: activity)
                : SimpleMission.fromJson(data: activity))
            .toList(),
      );

  @override
  UserEntity toEntity(){
    return UserEntity(
      id: id,
      account: account,
      name: userName,
      introduction: introduction,
      // photoId: photoId,
      photo: photo,
      tags: tags.map((tag) => UserTagEntity.fromModel(tag)).toList(),
      joinedWorkspaces: joinedWorkspaces,
      // joinedWorkspaceIds: joinedWorkspaceIds,
      contributingActivities: contributingActivities,
    );
  }

  // factory UserModel.fromEntity(UserEntity entity) {
  //   return UserModel(
  //     accountId: entity.id ?? defaultAccount.id,
  //     userName: entity.name,
  //     introduction: entity.introduction.isEmpty ? entity.name : entity.introduction,
  //     photo: entity.photo ?? defaultAccount.photo,
  //     tags: entity.tags.map((tag) => UserTagModel(title: tag.title, content: tag.content)).toList(),
  //     joinedWorkspaces: entity.joinedWorkspaces,
  //     contributingActivities: entity.contributingActivities,
  //   );
  // }

  @override
  String toString() {
    return {
      'id': this.id,
      'user_name': this.userName,
      'introduction': this.introduction,
      'tags': this.tags,
      'joined_workspaces': this.joinedWorkspaces,
      'contributing_activities': this.contributingActivities,
    }.toString();
  }

  @override
  bool operator ==(Object other) {
    return this.toString() == other.toString();
  }

  @override
  int get hashCode => id;
}
