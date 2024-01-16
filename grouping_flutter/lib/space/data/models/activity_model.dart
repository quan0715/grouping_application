// create event & mission super class or activity parent class?
import 'package:grouping_project/core/data/models/nest_workspace.dart';
import 'package:grouping_project/core/util/base_model.dart';
import 'package:grouping_project/space/data/models/mission_model.dart';
import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';
import 'package:grouping_project/space/domain/entities/activity_entity.dart';
// import 'package:grouping_project/model/workspace/data_model.dart';

abstract class ActivityModel implements BaseModel<ActivityEntity>{
  final int id;
  String title;
  String introduction;
  // List<String> tags;
  UserModel creator;
  DateTime createTime;
  NestWorkspace belongWorkspace;
  // List<int> parentMissionIDs;
  List<MissionModel> childMissions;
  List<UserModel> contributors;
  List<DateTime> notifications;

  ActivityModel(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.creator,
      required this.createTime,
      // required this.tags,
      required this.notifications,
      required this.belongWorkspace,
      // required this.parentMissionIDs,
      required this.childMissions});
  // EditableCardModel(
  //     {this.title = 'default',
  //     this.contributorIds = const [],
  //     this.introduction = 'default',
  //     this.notifications = const [],
  //     this.tags = const [],
  //     required this.ownerAccount,
  //     super.id = '',
  //     super.databasePath = '',
  //     super.storageRequired = false});

  // EditableCardModel fromJson({required String id, required Map<String, dynamic> data});

  Map<String, dynamic> toJson();

}
