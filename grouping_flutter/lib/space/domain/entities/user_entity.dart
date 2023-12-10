import 'package:grouping_project/core/theme/color.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';

class UserEntity {
  final int? id;
  String account;
  String name;
  // String nickname;
  // String slogan;
  String introduction;
  ImageModel? photo;
  List<UserTagModel> tags;
  List<WorkspaceModel> joinedWorkspaces;
  List<ActivityModel> contributingActivities;
  final spaceColor = AppColor.mainSpaceColor;

  // build constructor
  UserEntity({
    this.id,
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

  factory UserEntity.fromModel(UserModel account) {
    return UserEntity(
      id: account.id,
      account: account.account,
      name: account.userName,
      introduction: account.introduction,
      // photoId: account.photoId,
      photo: account.photo,
      tags: account.tags,
      joinedWorkspaces: account.joinedWorkspaces,
      // joinedWorkspaceIds: account.joinedWorkspaceIds,
      contributingActivities: account.contributingActivities,
    );
  }

  @override
  String toString() {
    // return 'UserEntity: id: $id, account: $account, name: $name, nickname: $nickname, slogan: $slogan, introduction: $introduction, photo: $photo, tags: $tags, joinedWorkspaces: $joinedWorkspaces, contributingActivities: $contributingActivities';
    // print each line with break line
    return 'UserEntity: id: $id\naccount: $account\nname: $name\nintroduction: $introduction\nphoto: $photo\ntags: $tags\njoinedWorkspaces: $joinedWorkspaces\ncontributingActivities: $contributingActivities';
  }
}
