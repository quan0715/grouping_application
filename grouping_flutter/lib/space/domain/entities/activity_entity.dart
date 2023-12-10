import 'package:grouping_project/space/data/models/user_model.dart';
import 'package:grouping_project/space/domain/entities/user_entity.dart';

abstract class ActivityEntity {
  final int? id;
  String title;
  String introduction;
  List<int> contributors;
  List<DateTime> notifications;
  late UserModel creatorAccount;
  late UserEntity creator;

  ActivityEntity(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.notifications,
      UserModel? creatorAccount,
      UserEntity? creator}) {
        if (creatorAccount != null) {
          creator = UserEntity.fromModel(creatorAccount);
        } else if (creator != null) {
          creatorAccount = UserModel.fromEntity(creator);
        }
  }
}
