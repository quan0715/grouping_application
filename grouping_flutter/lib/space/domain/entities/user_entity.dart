import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/core/util/base_entity.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';

class UserEntity implements BaseEntity<UserModel>{
  final int id;
  String account;
  String name;
  // String nickname;
  // String slogan;
  String introduction;
  ImageModel? photo;
  List<UserTagEntity> tags;
  List<NestWorkspace> joinedWorkspaces;
  List<ActivityModel> contributingActivities;
  final spaceColor = AppColor.mainSpaceColor;

  // build constructor
  UserEntity({
    required this.id,
    required this.account,
    required this.name,
    required this.introduction,
    // required this.photoId,
    required this.photo,
    required this.tags,
    required this.joinedWorkspaces,
    // required this.joinedWorkspaceIds,
    required this.contributingActivities,
  });

  @override
  UserModel toModel() {
    return UserModel(
      id: id,
      account: account,
      userName: name,
      introduction: introduction.isEmpty ? name : introduction,
      photo: photo,
      tags: tags.map((tag) => UserTagModel(title: tag.title, content: tag.content)).toList(),
      joinedWorkspaces: joinedWorkspaces,
      contributingActivities: contributingActivities,
    );
  }

  // factory UserEntity.fromModel(UserModel account) {
  //   return UserEntity(
  //     id: account.id,
  //     account: account.account,
  //     name: account.userName,
  //     introduction: account.introduction,
  //     // photoId: account.photoId,
  //     photo: account.photo,
  //     tags: account.tags.map((tag) => UserTagEntity.fromModel(tag)).toList(),
  //     joinedWorkspaces: account.joinedWorkspaces,
  //     // joinedWorkspaceIds: account.joinedWorkspaceIds,
  //     contributingActivities: account.contributingActivities,
  //   );
  // }

  @override
  String toString() {
    // return 'UserEntity: id: $id, account: $account, name: $name, nickname: $nickname, slogan: $slogan, introduction: $introduction, photo: $photo, tags: $tags, joinedWorkspaces: $joinedWorkspaces, contributingActivities: $contributingActivities';
    // print each line with break line
    return 'UserEntity: id: $id\naccount: $account\nname: $name\nintroduction: $introduction\nphoto: $photo\ntags: $tags\njoinedWorkspaces: $joinedWorkspaces\ncontributingActivities: $contributingActivities';
  }
}

class UserTagEntity extends UserTagModel{
  UserTagEntity({
    required super.title, 
    required super.content
  });

  factory UserTagEntity.emptyTag() 
    => UserTagEntity(title: "", content: "");

  factory UserTagEntity.fromModel(UserTagModel tag)
    => UserTagEntity(title: tag.title, content: tag.content);

  factory UserTagEntity.exampleTag() 
    => UserTagEntity(title: "生日", content: "1999/99/99"); 

  @override
  String toString() {
    return 'UserTagEntity: title: $title, content: $content';
  }

  UserTagModel toModel() => UserTagModel(title: title, content: content);

  UserTagEntity copy() => UserTagEntity(title: title, content: content);
}
