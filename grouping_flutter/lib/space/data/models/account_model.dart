// ignore_for_file: unnecessary_this
// import 'dart:typed_data';
import 'package:grouping_project/space/data/models/editable_card_model.dart';
import 'package:grouping_project/space/data/models/image_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';

// import '../workspace/data_model.dart';

/// ## the type for [AccountModel.tags]
/// * [tag] : the key for this tag
/// * [content] : the value for this tag
class AccountTagModel {
  String tag;
  String content;
  AccountTagModel({required this.tag, required this.content});

  @override
  String toString() {
    return 'Account Tag: $tag : $content';
  }
}

/// ## a data model for account, either user or group
/// * ***DO NOT*** pass or set id for AccountModel
/// * to upload/download, use `DataController`
class AccountModel {
  final int? id;
  String account;
  String name;
  String nickname;
  String slogan;
  String introduction;
  // String photoId;
  // Uint8List photo;
  ImageModel? photo;
  List<AccountTagModel> tags;
  List<WorkspaceModel> joinedWorkspaces;
  // List<String> joinedWorkspaceIds;
  List<EditableCardModel> contributingActivities;
  // List<String> associateEntityId;
  // List<AccountModel> associateEntityAccount;
  // int color;

  /// default account that all attribute is set to a default value
  static final AccountModel defaultAccount = AccountModel._default();

  /// default constructor, only for default account
  AccountModel._default()
      : this.id = -1,
        // this.color = 0xFFFCBF49,
        this.account = 'unknown',
        this.name = 'unknown',
        this.nickname = 'unknown',
        this.slogan = 'unknown',
        this.introduction = 'unknown',
        this.tags = [],
        // this.photoId = 'unknown',
        this.photo = null,
        this.joinedWorkspaces = [],
        this.contributingActivities = [];

  /// ## a data model for account, either user or group
  /// * ***DO NOT*** pass or set id for AccountModel
  /// * to upload/download, use `DataController`
  AccountModel({
    int? accountId,
    String? account,
    String? name,
    String? nickname,
    String? slogan,
    String? introduction,
    // String? photoId,
    ImageModel? photo,
    List<AccountTagModel>? tags,
    List<WorkspaceModel>? joinedWorkspaces,
    List<EditableCardModel>? contributingActivities,
    // List<String>? associateEntityId,
    // List<AccountModel>? associateEntityAccount,
  })  : this.id = accountId ?? defaultAccount.id,
        this.account = account ?? defaultAccount.account,
        this.name = name ?? defaultAccount.name,
        // this.color = color ?? defaultAccount.color,
        this.nickname = nickname ?? defaultAccount.nickname,
        this.slogan = slogan ?? defaultAccount.slogan,
        this.introduction = introduction ?? defaultAccount.introduction,
        this.photo = photo ?? defaultAccount.photo,
        this.tags = tags ?? List.from(defaultAccount.tags),
        // this.photoId = photoId ?? defaultAccount.photoId,
        this.joinedWorkspaces =
            joinedWorkspaces ?? List.from(defaultAccount.joinedWorkspaces),
        this.contributingActivities = contributingActivities ??
            List.from(defaultAccount.contributingActivities);

  /// ### A method to copy an instance from this instance, and change some data with given.
  AccountModel copyWith({
    int? accountId,
    String? account,
    String? name,
    // int? color,
    String? nickname,
    String? slogan,
    String? introduction,
    ImageModel? photo,
    List<AccountTagModel>? tags,
    // String? photoId,
    List<WorkspaceModel>? joinedWorkspaces,
    List<EditableCardModel>? contributingActivities,
    // List<String>? associateEntityId,
    // List<AccountModel>? associateEntityAccount,
  }) {
    return AccountModel(
      accountId: accountId ?? this.id,
      account: account ?? this.account,
      name: name ?? this.name,
      // color: color ?? this.color,
      nickname: nickname ?? this.nickname,
      slogan: slogan ?? this.slogan,
      tags: tags ?? this.tags,
      introduction: introduction ?? this.introduction,
      // photoId: photoId ?? this.photoId,
      photo: photo ?? this.photo,
      joinedWorkspaces: joinedWorkspaces ?? this.joinedWorkspaces,
      contributingActivities:
          contributingActivities ?? this.contributingActivities,
      // associateEntityId: associateEntityId ?? this.associateEntityId,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': this.id,
        'real_name': this.name,
        'user_name': this.nickname,
        'account': this.account,
        // 'color': this.color,
        'slogan': this.slogan,
        'introduction': this.introduction,
        'tags': this.tags,
        'photo': this.photo?.toJson(),
        // 'tag_contents': _toBackendTagContent(this.tags),
        'joined_workspaces': this.joinedWorkspaces,
        'contributing_activities': this.contributingActivities,
        // 'photo_id': this.photoId,
        // 'associate_entity_id': this.associateEntityId,
      };

  factory AccountModel.fromJson({required Map<String, dynamic> data}) =>
      AccountModel(
        accountId: data['id'] as int, // TODO: id? userid?
        account: data['account'] as String,
        name: data['real_name'] as String,
        nickname: data['user_name'] as String,
        introduction: data['introduction'] as String,
        // color: data['color'] as int,
        slogan: data['slogan'] as String,
        photo: data['photo'] != null ? ImageModel.fromJson(data['photo'] as Map<String, dynamic>) : null,
        tags: data['tags'].cast<AccountTagModel>() as List<AccountTagModel>,
        // tags: (data['tags'] is Iterable) && (data['tag_contents'] is Iterable)
        //     ? _fromBackendTags(
        //         List.from(data['tags']), List.from(data['tag_contents']))
        //     : null,
        joinedWorkspaces: data['joined_workspaces'].cast<WorkspaceModel>()
            as List<WorkspaceModel>,
        contributingActivities: data['contributing_activities']
            .cast<EditableCardModel>() as List<EditableCardModel>,
        // photoId: data['photo_id'],
        // associateEntityId: data['associate_entity_id'] is Iterable
        //     ? List.from(data['associate_entity_id'])
        //     : null
      );
  @override
  String toString() {
    return {
      'id': this.id,
      'real_name': this.name,
      'user_name': this.nickname,
      'account': this.account,
      // 'color': this.color,
      'slogan': this.slogan,
      'introduction': this.introduction,
      'tags': this.tags,
      // 'tag_contents': _toBackendTagContent(this.tags),
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