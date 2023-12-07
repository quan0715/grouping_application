// ignore_for_file: unnecessary_this
// import 'dart:typed_data';
import 'package:grouping_project/space/data/models/activity_model.dart';
import 'package:grouping_project/core/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/data/models/workspace_model_lib.dart';

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
    return 'Account Tag: $title : $content';
  }
}

/// ## a data model for account, either user or group
/// * ***DO NOT*** pass or set id for AccountModel
/// * to upload/download, use `DataController`
class UserModel {
  final int? id;
  String account;
  String password;
  String name;
  String introduction;
  ImageModel? photo;
  List<UserTagModel> tags;
  List<WorkspaceModel> joinedWorkspaces;
  List<ActivityModel> contributingActivities;

  /// default account that all attribute is set to a default value
  static final UserModel defaultAccount = UserModel._default();

  /// default constructor, only for default account
  UserModel._default()
      : this.id = -1,
        this.account = 'unknown',
        this.password = 'unknown',
        this.name = 'unknown',
        this.introduction = 'unknown',
        this.photo = null,
        this.tags = [],
        this.joinedWorkspaces = [],
        this.contributingActivities = [];

  /// ## a data model for account, either user or group
  /// * ***DO NOT*** pass or set id for AccountModel
  /// * to upload/download, use `DataController`
  UserModel({
    int? accountId,
    String? account,
    String? password,
    String? name,
    String? introduction,
    ImageModel? photo,
    List<UserTagModel>? tags,
    List<WorkspaceModel>? joinedWorkspaces,
    List<ActivityModel>? contributingActivities,
  })  : this.id = accountId ?? defaultAccount.id,
        this.account = account ?? defaultAccount.account,
        this.password = password ?? defaultAccount.password,
        this.name = name ?? defaultAccount.name,
        this.introduction = introduction ?? defaultAccount.introduction,
        this.photo = photo ?? defaultAccount.photo,
        this.tags = tags ?? List.from(defaultAccount.tags),
        this.joinedWorkspaces =
            joinedWorkspaces ?? List.from(defaultAccount.joinedWorkspaces),
        this.contributingActivities = contributingActivities ??
            List.from(defaultAccount.contributingActivities);

  /// ### A method to copy an instance from this instance, and change some data with given.
  // UserModel copyWith({
  //   int? accountId,
  //   String? account,
  //   String? name,
  //   // int? color,
  //   String? nickname,
  //   String? slogan,
  //   String? introduction,
  //   ImageModel? photo,
  //   List<UserTagModel>? tags,
  //   // String? photoId,
  //   List<WorkspaceModel>? joinedWorkspaces,
  //   List<EditableCardModel>? contributingActivities,
  //   // List<String>? associateEntityId,
  //   // List<AccountModel>? associateEntityAccount,
  // }) {
  //   return UserModel(
  //     accountId: accountId ?? this.id,
  //     account: account ?? this.account,
  //     name: name ?? this.name,
  //     tags: tags ?? this.tags,
  //     introduction: introduction ?? this.introduction,
  //     // photoId: photoId ?? this.photoId,
  //     photo: photo ?? this.photo,
  //     joinedWorkspaces: joinedWorkspaces ?? this.joinedWorkspaces,
  //     contributingActivities:
  //         contributingActivities ?? this.contributingActivities,
  //     // associateEntityId: associateEntityId ?? this.associateEntityId,
  //   );
  // }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'user_name': this.name,
        'introduction': this.introduction,
        'photo': this.photo?.toJson(),
        'tags': this.tags.map((tag) => tag.toJson()).toList(),
        'joined_workspaces': this
            .joinedWorkspaces
            .map((workspace) => workspace.toJson())
            .toList(),
        'contributing_activities': this
            .contributingActivities
            .map((activity) => activity.toJson())
            .toList(),
      };

  factory UserModel.fromJson({required Map<String, dynamic> data}) => UserModel(
        accountId: data['id'] as int,
        account: data['account'] as String,
        password: data['password'] as String,
        name: data['user_name'] as String,
        introduction: data['introduction'] as String,
        photo: data['photo'] != null
            ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>)
            : null,
        tags: ((data['tags'] ?? []).cast<Map<String, dynamic>>()
                as List<Map<String, dynamic>>)
            .map((tag) => UserTagModel.fromJson(data: tag))
            .toList(),
        joinedWorkspaces: ((data['joined_workspaces'] ?? [])
                .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>)
            .map((workspace) => WorkspaceModel.fromJson(data: workspace))
            .toList(),
        // joinedWorkspaces: data['joined_workspaces'].cast<WorkspaceModel>()
        //     as List<WorkspaceModel>,
        contributingActivities: ((data['contributing_activities'] ?? [])
                .cast<Map<String, dynamic>>() as List<Map<String, dynamic>>)
            .map((activity) => activity['event'] != null
                ? EventModel.fromJson(data: activity)
                : MissionModel.fromJson(data: activity))
            .toList(),
      );
  @override
  String toString() {
    return {
      'id': this.id,
      'user_name': this.name,
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
  int get hashCode => id!;
}
