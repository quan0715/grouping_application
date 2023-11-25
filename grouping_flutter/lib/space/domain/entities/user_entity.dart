import 'package:grouping_project/space/data/models/account_model.dart';

class UserEntity {
  UserEntity();
  // the entity class is the same as the model class
  factory UserEntity.fromModel(AccountModel account){
    return UserEntity();
  }
}