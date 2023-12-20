import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/data/models/workspace_model.dart';

abstract class ActivityEntity {
  final int? id;
  String title;
  String introduction;
  List<int> contributors;
  List<DateTime> notifications;
  UserModel creatorAccount;
  WorkspaceModel belongWorkspace;
  // late UserEntity creator;

  ActivityEntity(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.notifications,
      required this.creatorAccount,
      required this.belongWorkspace,
      });
}