import 'package:grouping_project/space/data/models/account_model.dart';
import 'package:grouping_project/space/data/models/editable_card_model.dart';
import 'package:grouping_project/space/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';

class UserEntity{
  final int? id;
  String account;
  String name;
  String nickname;
  String slogan;
  String introduction;
  ImageModel? photo;
  List<AccountTagModel> tags;
  List<WorkspaceModel> joinedWorkspaces;
  List<EditableCardModel> contributingActivities;

  // build constructor
  UserEntity({
    this.id,
    required this.account,
    required this.name,
    required this.nickname,
    required this.slogan,
    required this.introduction,
    // required this.photoId,
    required this.photo,
    required this.tags,
    required this.joinedWorkspaces,
    // required this.joinedWorkspaceIds,
    required this.contributingActivities,
  });

  factory UserEntity.fromModel(AccountModel account){
    return UserEntity(
      id: account.id,
      account: account.account,
      name: account.name,
      nickname: account.nickname,
      slogan: account.slogan,
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
    return 'UserEntity: id: $id, account: $account, name: $name, nickname: $nickname, slogan: $slogan, introduction: $introduction, photo: $photo, tags: $tags, joinedWorkspaces: $joinedWorkspaces, contributingActivities: $contributingActivities';
  }
}