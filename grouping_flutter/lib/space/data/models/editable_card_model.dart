// create event & mission super class or activity parent class?
import 'package:grouping_project/core/util/data_mapper.dart';
import 'package:grouping_project/space/data/models/account_model.dart';
// import 'package:grouping_project/model/workspace/data_model.dart';

abstract class EditableCardModel extends DataMapper{
  final int? id;
  String title;
  String introduction;
  List<int> contributors;
  // List<String> tags;
  List<DateTime> notifications;
  AccountModel creatorAccount;

  EditableCardModel(
      {required this.id,
      required this.title,
      required this.introduction,
      required this.contributors,
      required this.creatorAccount,
      // required this.tags,
      required this.notifications});
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
