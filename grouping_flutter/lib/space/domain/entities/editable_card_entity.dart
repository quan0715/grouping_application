import 'package:grouping_project/space/data/models/user_model.dart';

abstract class EditableCardEntity {
  final int? id;
  final String title;
  final String introduction;
  final List<int> contributors;
  final List<DateTime> notifications;
  final UserModel creatorAccount;

  EditableCardEntity(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.notifications,
      required this.creatorAccount});
}
